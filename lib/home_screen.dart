import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/achievements_screen.dart';
import 'package:sleep_tracker/history_screen.dart';
import 'package:sleep_tracker/settings_screen.dart';
import 'package:sleep_tracker/sleep_session_provider.dart'; // Ensure to use your provider file

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  // A list of screens for each bottom navigation button
  static final List<Widget> _screens = <Widget>[
    HomePageContent(),
    SettingsScreen(),
    HistoryScreen(),
    AchievementsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Tracker Home'),
      ),
      body: Center(
        // Display the selected screen
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Achievements',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePageContent extends ConsumerWidget {
  Future<void> _selectTime(BuildContext context, WidgetRef ref, bool isStartTime) async {
    final sleepSessionNotifier = ref.read(sleepSessionProvider.notifier);
    final sleepSession = ref.watch(sleepSessionProvider);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (sleepSession.startTime ?? TimeOfDay.now())
          : (sleepSession.endTime ?? TimeOfDay.now()),
    );

    if (picked != null) {
      if (isStartTime) {
        sleepSessionNotifier.setStartTime(picked);
      } else {
        sleepSessionNotifier.setEndTime(picked);
      }
    }
  }

  void _startSession(BuildContext context, WidgetRef ref) async {
    final sleepSessionNotifier = ref.read(sleepSessionProvider.notifier);

    await sleepSessionNotifier.startSession(); // Make sure to initialize local notifications here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sleep session started!')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepSession = ref.watch(sleepSessionProvider);

    var _isButtonHovered = false;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Circular button to start the session
          Center(
            child: MouseRegion(
              onEnter: (_) {
                  _isButtonHovered = true; 
              },
              onExit: (_) {
                  _isButtonHovered = false; 
                }
              ,
            child: GestureDetector(
              onTap: () => _startSession(context, ref),

              child: Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 196, 180, 35),
                ),
                 child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: _isButtonHovered ? 130 : 120,
                height: _isButtonHovered ? 130 : 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                  boxShadow: [
                    BoxShadow(
                      color: _isButtonHovered ? Colors.blue.withOpacity(0.5) : Colors.blue.withOpacity(0.3),
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Start\nSession',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
            ),
          ),
          SizedBox(height: 20),

          // Display remaining time
          Center(
            child: Text(
              'Time left: ${sleepSession.getRemainingTime().inMinutes} minutes',
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 30),

          // Editable Start Time
          ListTile(
            title: Text('Start Time:'),
            trailing: Text(sleepSession.getFormattedTime(sleepSession.startTime)),
            onTap: () => _selectTime(context, ref, true),
          ),

          // Editable End Time
          ListTile(
            title: Text('End Time:'),
            trailing: Text(sleepSession.getFormattedTime(sleepSession.endTime)),
            onTap: () => _selectTime(context, ref, false),
          ),

          SizedBox(height: 20),

          // Alarm Settings with Vibration and Sound
          Text('Alarm Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: Text('Vibration'),
            value: sleepSession.vibrationEnabled,
            onChanged: (bool value) {
              ref.read(sleepSessionProvider.notifier).toggleVibration(value);
            },
          ),
          SwitchListTile(
            title: Text('Sound'),
            value: sleepSession.soundEnabled,
            onChanged: (bool value) {
              ref.read(sleepSessionProvider.notifier).toggleSound(value);
            },),
        ],
      ),
    );
  }
}
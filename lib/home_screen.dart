import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/achievements_screen.dart';
import 'package:sleep_tracker/history_screen.dart';
import 'package:sleep_tracker/settings_screen.dart';
import 'package:sleep_tracker/sleep_session_provider.dart';
import 'nothern_lights.dart';
import 'session_summary_screen.dart';


class ButtonHoverNotifier extends StateNotifier<bool> {
  ButtonHoverNotifier() : super(false);

  void setHovered(bool isHovered) {
    state = isHovered;
  }
}

final buttonHoverProvider = StateNotifierProvider<ButtonHoverNotifier, bool>((ref) {
  return ButtonHoverNotifier();
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    const HomePageContent(),
    const SettingsScreen(),
    const HistoryScreen(),
    const AchievementsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 0, 6, 88), 
          ),
          const Center(
            child: NorthernLights(beginDirection: Alignment.topLeft, endDirection: Alignment.bottomRight,),
          ),
          Center(
            child: _screens.elementAt(_selectedIndex),
          ),
        ],
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
        fixedColor: const Color.fromARGB(255, 56, 17, 107),
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePageContent extends ConsumerWidget {
  const HomePageContent({super.key});

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

  void _toggleSession(BuildContext context, WidgetRef ref) async {
    final sleepSessionNotifier = ref.read(sleepSessionProvider.notifier);
    final sleepSession = ref.watch(sleepSessionProvider);
    if (sleepSession.isSessionActive) {
      await sleepSessionNotifier.cancelSession();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sleep session canceled!')),
      );
    } else {
      await sleepSessionNotifier.startSession();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sleep session started!')),
      );
      Timer(sleepSession.getRemainingTime(), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SessionSummaryScreen()),
      );
    });
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepSession = ref.watch(sleepSessionProvider);
    final isButtonHovered = ref.watch(buttonHoverProvider);
    
   return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: MouseRegion(
                onEnter: (_) => ref.read(buttonHoverProvider.notifier).setHovered(true),
                onExit: (_) => ref.read(buttonHoverProvider.notifier).setHovered(false),
                child: GestureDetector(
                  onTap: () =>  _toggleSession(context, ref),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double screenHeight = MediaQuery.of(context).size.height;
                      double buttonSize = screenHeight * 7 / 15;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isButtonHovered ? buttonSize * 1.05 : buttonSize,
                        height: isButtonHovered ? buttonSize * 1.05 : buttonSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          gradient: RadialGradient(
                            colors: [
                              Colors.transparent,
                              const Color.fromARGB(0, 155, 135, 243).withOpacity(0.5),
                            ],
                            radius: 0.85,
                            center: Alignment.topLeft,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isButtonHovered
                                  ? const Color.fromARGB(57, 158, 139, 204).withOpacity(0.7)
                                  : const Color.fromARGB(255, 90, 57, 168).withOpacity(0.4),
                              offset: const Offset(0, 4),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                              sleepSession.isSessionActive ? 'Cancel\nSession' : 'Start\nSession',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                shadows: [
                                  Shadow(
                                    blurRadius: 8.0,
                                    color: Colors.white,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                        ),
                      )
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.teal[50]?.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    sleepSession.isSessionActive? 
                    'Time left: ${_formatDuration(sleepSession.getRemainingTime())}' : 'Time left: 00:00',
                    style: TextStyle(
                      fontSize: 20, 
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w300, 
                      fontFamily: 'Montserrat',
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 30),
            ListTile(
                title: const Text(
                  'Start Time:',
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.w400, 
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    letterSpacing: 1.2, 
                  ),
                ),
                trailing: AnimatedDefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.w300, 
                    fontSize: 20,
                    fontFamily: 'Montserrat', 
                    letterSpacing: 1.1,
                  ),
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    sleepSession.getFormattedTime(sleepSession.startTime),
                  ),
                ),
                onTap: () => _selectTime(context, ref, true),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: Colors.teal[50], 
                hoverColor: Colors.teal.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),

            const SizedBox(height: 10),
            ListTile(
              title: const Text(
                'End Time:',
                style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                    fontFamily: 'Montserrat', 
                    letterSpacing: 1.1,
                  ),
              ),
              trailing: AnimatedDefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.w300, 
                    fontSize: 20,
                    fontFamily: 'Montserrat', 
                    letterSpacing: 1.1,
                  ),
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    sleepSession.getFormattedTime(sleepSession.endTime),
                  ),
                ),
              onTap: () => _selectTime(context, ref, false),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              tileColor: Colors.teal[50],
              hoverColor: Colors.teal.withOpacity(0.1),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            ),
          ],
        ),
      ),
      )
    ],
  );
 }
}

String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  return '$hours:$minutes';
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'home_screen.dart';
import 'onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeNotificationPlugin();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _initializeNotificationPlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Request notification permission
  Future<void> _requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      print('Notification permission granted');
    } else {
      print('Notification permission denied');
    }
  }

  // Simulate requesting alarm permission (no direct permission request for alarm, this is a mock)
  Future<void> _requestAlarmPermission() async {
    // In reality, setting alarms does not require permission but we mock it for the user flow
    print('Alarm permission granted (simulated)');
  }

  @override
  Widget build(BuildContext context) {
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Sleep Tracker'),
        actions: [
          if (_currentPage != 2) // Show "Skip" button on all pages except the last one
            TextButton(
              onPressed: () {
                _pageController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
              },
              child: Text(
                'Skip',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                buildOnboardingPage(
                  context,
                  title: 'Welcome to Sleep Tracker',
                  description: 'Track your sleep for a better tomorrow.',
                  image: Icons.bedtime,
                  onNextPage: () {
                    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  },
                ),
                buildOnboardingPage(
                  context,
                  title: 'Sleep Session Tracking',
                  description: 'Track your sleep session, duration, and sleep phases.',
                  image: Icons.timer,
                  onNextPage: () {
                    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  },
                ),
                buildOnboardingPage(
                  context,
                  title: 'Permissions',
                  description: 'We need some permissions to enhance your experience.',
                  image: Icons.notifications,
                  isLastPage: true,
                  onComplete: () async {
                    // Request both notification and alarm permissions
                    await _requestNotificationPermission();
                    await _requestAlarmPermission();

                    // Complete onboarding
                    onboardingNotifier.state = true;
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
              ],
            ),
          ),
          // Display page indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                height: 10.0,
                width: _currentPage == index ? 20.0 : 10.0,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildOnboardingPage(BuildContext context,
      {required String title,
      required String description,
      required IconData image,
      bool isLastPage = false,
      VoidCallback? onNextPage,
      VoidCallback? onComplete}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(image, size: 100, color: Colors.blue),
          SizedBox(height: 40),
          Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text(description, style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
          SizedBox(height: 40),
          if (!isLastPage)
            ElevatedButton(
              onPressed: onNextPage,
              child: Text('Next'),
            ),
          if (isLastPage)
            ElevatedButton(
              onPressed: onComplete,
              child: Text('Get Started'),
            ),
        ],
      ),
    );
  }
}

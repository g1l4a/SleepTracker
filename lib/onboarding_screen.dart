import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'home_screen.dart';
import 'onboarding_provider.dart';
import 'nothern_lights.dart';


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

  Future<void> _requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      print('Notification permission granted');
    } else {
      print('Notification permission denied');
    }
  }

  void _nextPage() {
    if (_currentPage < 2) { 
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }


  
  @override
  Widget build(BuildContext context) {
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
           Container(
            color: const Color.fromARGB(255, 0, 6, 88), 
          ),
          const Center(
            child: NorthernLights(beginDirection: Alignment.topRight, endDirection: Alignment.bottomLeft,),
          ),
          Column(
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
                      onNextPage: _nextPage,
                    ),
                    buildOnboardingPage(
                      context,
                      title: 'Sleep Session Tracking',
                      description:
                          'Track your sleep session and duration',
                      image: Icons.timer,
                      onNextPage: _nextPage
                    ),
                    buildOnboardingPage(
                      context,
                      title: 'Permissions',
                      description:
                          'We need some permissions to enhance your experience.',
                      image: Icons.notifications,
                      isLastPage: true,
                      onComplete: () async {
                        await _requestNotificationPermission();
                        onboardingNotifier.completeOnboarding();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    height: 10.0,
                    width: _currentPage == index ? 20.0 : 10.0,
                    decoration: BoxDecoration(
                      color:
                          _currentPage == index ? Colors.white : Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  );
                }),
              ),
            ],
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
          Icon(image, size: 100, color: const Color.fromARGB(255, 255, 243, 134)),
          const SizedBox(height: 40),
          Text(title,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 235, 214, 125), fontFamily: 'Montserrat',)),
          const SizedBox(height: 20),
          Text(description,
              style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 252, 242, 211), fontFamily: 'Montserrat',),
              textAlign: TextAlign.center),
          const SizedBox(height: 40),
          if (!isLastPage)
            ElevatedButton(
                  onPressed: onNextPage,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 72, 54, 116),
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 8, 
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 237, 233, 248),
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),

          if (isLastPage)
            ElevatedButton(                                                       
                  onPressed: onComplete,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 72, 54, 116),
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 8, 
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 237, 233, 248),
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
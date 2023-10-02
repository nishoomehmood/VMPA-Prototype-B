import 'dart:ffi';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpma_test_phase/controller/controller.dart';
import 'package:vpma_test_phase/screens/home/home.dart';
import 'package:vpma_test_phase/screens/onboarding/screen_one.dart';


int? initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  await Get.putAsync(() async => preferences);
  initScreen = await preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final controller = PlayerController();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Music player App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Colors.transparent,
      ),
      initialRoute: initScreen == 0 || initScreen == null ? 'onboard' : 'home',
      routes: {
        'home': (context) => HomePage(controller: controller),
        'onboard': (context) => OnboardingScreenOne(controller: controller),
      },
    );
  }
}

// ignore: use_key_in_widget_constructors
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Container(
          child: Image.asset('assets/images/app_logo.png'),
        ),
        backgroundColor: Colors.white,
        duration: 1200,
        splashIconSize: 180,
        pageTransitionType: PageTransitionType.fade,
        nextScreen: MyApp());
  }
}

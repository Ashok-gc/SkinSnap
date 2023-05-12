import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skinsnap/src/screen/splash_screen.dart';

int? isviewed;
void main() async {
  // ignore: prefer_const_constructors
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAq6FiH6u0Nc-6GW3fy26NfqEDFUOZNPFY",
          appId: "1:414378218880:android:5a92f43bcbe1ee36cf5d65",
          messagingSenderId: "XXX",
          projectId: "skindiseaseprediction-a96d9"));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // ignore: prefer_const_constructors
        home: SplashScreen(
          isviewed: isviewed,
        )
        // home: isviewed != 0 ? OnBoardingScreen() : LoginScreen(),
        );
  }
}

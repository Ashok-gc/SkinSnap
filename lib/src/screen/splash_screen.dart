import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skinsnap/src/screen/login_screen.dart';
import 'package:skinsnap/src/screen/onboarding.dart';

class SplashScreen extends StatefulWidget {
  int? isviewed;
  SplashScreen({super.key, this.isviewed});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset(
        "assets/logo/logo.png",
      ),
      title: Text(
        "Skin Disease Prediction",
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.white54,
      showLoader: true,
      loaderColor: Colors.indigo,
      navigator:
          widget.isviewed != 0 ? const OnBoardingScreen() : const LoginScreen(),
      durationInSeconds: 4,
    );
  }
}

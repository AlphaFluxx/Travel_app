
// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'widget/animations.dart'; 
import 'auth/loginScreen.dart'; 

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        createFadeRoute(LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/image/logo_final_white.png',
              width: 300,
              height: 300,
            ),
            const SizedBox(height: 10),
            const Text(
              'HorizonTravel',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

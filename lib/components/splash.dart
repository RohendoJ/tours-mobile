import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tour_app/screens/auth/main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 2)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/download.png',
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
            ),
          );
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}

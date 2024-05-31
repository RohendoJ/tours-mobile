import 'package:flutter/material.dart';
import 'package:tour_app/screens/auth/register.dart';
import 'package:tour_app/screens/auth/login.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/download.png', width: 150, height: 150),
            const SizedBox(height: 30),
            const Text(
              'Selamat Datang di Aplikasi Tour App',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 30),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded edges
                  ),
                  side: const BorderSide(color: Colors.black), // Teal border
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                  child: Text(
                    'Masuk',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  child: Text(
                    'Daftar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

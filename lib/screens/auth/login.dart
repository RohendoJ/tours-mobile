import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_app/screens/auth/register.dart';
import 'package:tour_app/screens/auth/main.dart';
import 'package:tour_app/screens/tours/main.dart';
import 'package:tour_app/services/services_signin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool isButtonDisabled = true;
  bool isLoading = false;

  final SignInService _signInService = SignInService();

  @override
  void initState() {
    super.initState();
    username.addListener(validateInput);
    password.addListener(validateInput);
  }

  void setAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', token);
  }

  void validateInput() {
    setState(() {
      isButtonDisabled =
          !(username.text.isNotEmpty && password.text.isNotEmpty);
    });
  }

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
    });

    final signInResponse = await _signInService.signInAccount(
      username.text,
      password.text,
    );

    if (signInResponse != null) {
      setAccessToken(signInResponse['access_token']);
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
              'Terjadi kesalahan saat melakukan login',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masuk Akun'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AuthScreen()),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Masuk Tour App',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
                controller: username,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
                controller: password,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 20),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: OutlinedButton(
                onPressed: isButtonDisabled || isLoading ? null : signIn,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(
                    color: isButtonDisabled || isLoading
                        ? Colors.black12
                        : Colors.black,
                  ),
                ),
                child: isLoading
                    ? const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.black),
                        ))
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 12),
                        child: Text(
                          'Masuk',
                          style: TextStyle(
                              color: isButtonDisabled
                                  ? Colors.black12
                                  : Colors.black),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.15),
                  child: const Text(
                    'Belum punya akun ?',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      'Daftar',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tour_app/screens/auth/login.dart';
import 'package:tour_app/screens/auth/main.dart';
import 'package:tour_app/services/services_signup.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController fullname = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cpassword = TextEditingController();

  bool isLoading = false;
  bool isButtonDisabled = true;

  final SignUpService _signUpService = SignUpService();

  @override
  void initState() {
    super.initState();
    username.addListener(validateInput);
    fullname.addListener(validateInput);
    password.addListener(validateInput);
    cpassword.addListener(validateInput);
  }

  void validateInput() {
    setState(() {
      isButtonDisabled = !(username.text.isNotEmpty &&
          fullname.text.isNotEmpty &&
          password.text.isNotEmpty &&
          cpassword.text.isNotEmpty &&
          password.text == cpassword.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun'),
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
              'Daftar Tour App',
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
                controller: fullname,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
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
            const SizedBox(height: 10),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
                controller: cpassword,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 20),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: ElevatedButton(
                onPressed: isButtonDisabled || isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });

                        final signUpResponse =
                            await _signUpService.signUpAccount(
                          username.text,
                          fullname.text,
                          password.text,
                        );

                        if (signUpResponse != null) {
                          Navigator.pushReplacement(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
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
                                      'Terjadi kesalahan saat melakukan daftar',
                                    ),
                                    actions: [
                                      TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          })
                                    ]);
                              });
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLoading
                    ? const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.black87,
                            )),
                      )
                    : const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        child: Text(
                          'Daftar',
                          style: TextStyle(color: Colors.white),
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
                    'Sudah punya akun ?',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 5,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Masuk',
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

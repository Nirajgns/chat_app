import 'package:chat_app/signup_screen.dart';
import 'package:chat_app/utils/snacks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'home/home_page.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  _loginUser(String email, String password) async {
    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => HomePage(),
            ),
            (route) => false);

        showSuccessSnack("Logged in successfully...");
      } else {
        showErrorSnack("Something went wrong...");
      }
    } on FirebaseAuthException catch (e) {
      showErrorSnack(e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
      ),
      body: Form(
        key: _loginFormKey,
        child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            TextFormField(
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(gapPadding: 20),
                labelText: "Email address...",
              ),
              controller: _emailController,
              validator: (value) {
                if (value != null &&
                    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                  return null;
                } else {
                  return "Please enter valid email";
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(gapPadding: 20),
                  labelText: "Password..."),
              controller: _passwordController,
              validator: (value) {
                if (value != null && value.length > 7) {
                  return null;
                } else {
                  return "please enter a valid password";
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_loginFormKey.currentState!.validate()) {
                    _loginUser(_emailController.text, _passwordController.text);
                  }
                },
                child: const Text("Login")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
                child: const Text("Don't have an account, sign up?"))
          ],
        ),
      ),
    );
  }
}

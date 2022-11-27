import 'package:chat_app/utils/snacks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  _signUPUser(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set({
          "name": _nameController.text,
          "email": _emailController.text,
          "uid": userCredential.user!.uid
        });
        showSuccessSnack("User created successfully...");
      } else {
        {
          showErrorSnack("Something went wrong...");
        }
      }
    } on FirebaseAuthException catch (e) {
      showErrorSnack(e.message.toString());
    } catch (e) {
      showErrorSnack(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signup Screen"),
      ),
      body: Form(
        key: _signupFormKey,
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            TextFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(gapPadding: 20),
                labelText: "Enter name.",
              ),
              controller: _nameController,
              validator: (value) {
                if (value != null && value.length > 2) {
                  return null;
                } else {
                  return "Enter a valid name.";
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(gapPadding: 20),
                labelText: "Enter e-mail.",
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
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(gapPadding: 20),
                hintText: "Enter password.",
              ),
              controller: _passwordController,
              validator: (value) {
                if (value != null && value.length > 7) {
                  return null;
                } else {
                  return "please enter a valid password";
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_signupFormKey.currentState!.validate()) {
                    _signUPUser(
                        _emailController.text, _passwordController.text);
                  }
                  // print(_emailController.text);
                  // print(_passwordController.text);
                },
                child: Text("Signup")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Already have an account, login?"))
          ],
        ),
      ),
    );
  }
}

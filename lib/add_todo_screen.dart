import 'package:chat_app/utils/snacks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController _addTodoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a todo..."),
      ),
      body: Form(
        child: Column(
          children: [
            SizedBox(height: 50),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Enter a new todo...",
                enabledBorder: OutlineInputBorder(gapPadding: 20),
              ),
              controller: _addTodoController,
            ),
            ElevatedButton(
              // onPressed: () {
              //   FirebaseFirestore.instance
              //       .collection("todos")
              //       .add({"name": "play cricket"});
              // },
              onPressed: () {
                FirebaseFirestore.instance.collection("todos").add(
                  {
                    "name": _addTodoController.text,
                  },
                );
                showSuccessSnack("New todo added...");
              },

              child: Text("Add todo"),
            )
          ],
        ),
      ),
    );
  }
}

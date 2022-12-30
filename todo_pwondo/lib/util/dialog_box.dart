import 'package:flutter/material.dart';
import 'package:todo_pwondo/util/my_button.dart';
import 'dart:io';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  DialogBox({super.key, required this.controller, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 200,
        child: Column(
          children: [
            TextField(
                controller: controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Add new task")),
            MyButton(title: "save", onPressed: onSave)
          ],
        ),
      ),
    );
  }
}

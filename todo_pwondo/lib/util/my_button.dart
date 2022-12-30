import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyButton extends StatelessWidget {
  final String title;
  VoidCallback onPressed;
  MyButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      onPressed: onPressed,
      color: Colors.black,
      textColor: Colors.white,
      padding: EdgeInsets.all(14),
      child: Text(title),
    );
  }
}

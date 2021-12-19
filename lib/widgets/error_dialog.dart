import 'package:flutter/material.dart';

class ErrorLog extends StatelessWidget {
  final String text;
  ErrorLog({required this.text});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(text),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

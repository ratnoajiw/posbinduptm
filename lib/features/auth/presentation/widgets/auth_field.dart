import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final bool isObsecureText;
  const AuthField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.isObsecureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText belum dimasukan!";
        }
        return null;
      },
      obscureText: isObsecureText,
    );
  }
}

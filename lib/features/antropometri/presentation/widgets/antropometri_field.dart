import 'package:flutter/material.dart';

class AntropometriField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String labelTextField;

  const AntropometriField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.labelTextField,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelTextField,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText belum dimasukan!';
        }
        return null;
      },
    );
  }
}

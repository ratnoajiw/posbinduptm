import 'package:flutter/material.dart';

class AntropometriField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;

  final bool readOnly;
  final VoidCallback? onTap;
  final IconData? suffixIcon;
  final String? suffixText; // Tambahkan parameter untuk satuan unit

  const AntropometriField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.suffixText, // Unit opsional
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon, color: Colors.blueAccent),
                onPressed: onTap,
              )
            : null,
        suffixText: suffixText,
        suffixStyle: const TextStyle(color: Colors.grey),
      ),
      readOnly: readOnly,
      onTap: onTap,
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText belum dimasukkan!';
        }
        return null;
      },
    );
  }
}

import 'package:flutter/material.dart';

class KolesterolTotalField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final IconData? suffixIcon;
  final String? suffixText;

  const KolesterolTotalField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return '$hintText belum dimasukkan!';
            }
            return null;
          },
        ),
        if (suffixText != null)
          Positioned(
            right: suffixIcon != null ? 40 : 16,
            top: 18,
            child: Text(
              suffixText!,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        if (suffixIcon != null)
          Positioned(
            right: 8,
            top: 5,
            child: IconButton(
              icon: Icon(suffixIcon, color: Colors.grey),
              onPressed: onTap,
            ),
          ),
      ],
    );
  }
}

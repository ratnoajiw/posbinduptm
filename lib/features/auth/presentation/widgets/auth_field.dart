import 'package:flutter/material.dart';

class AuthField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final bool isObsecureText;
  final String? Function(String?)? validator; // Tambahan validator

  const AuthField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.isObsecureText = false,
    this.validator, // Parameter tambahan
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool isObscured = true;

  @override
  void initState() {
    super.initState();
    isObscured = widget.isObsecureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        suffixIcon: widget.isObsecureText
            ? IconButton(
                icon: Icon(
                  isObscured ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    isObscured = !isObscured;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator ??
          (value) {
            if (value!.isEmpty) {
              return "${widget.labelText} harus diisi";
            }
            return null;
          },
      obscureText: isObscured,
    );
  }
}

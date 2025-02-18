import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';

class CustomDatePicker {
  static Future<String?> pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now, // Maksimal hanya hari ini
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppPallete.gradientGreen2,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  foregroundColor: AppPallete.gradientGreen2),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      return DateFormat("dd/MM/yyyy").format(picked);
    }
    return null;
  }
}

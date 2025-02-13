import 'package:flutter/material.dart';

class CustomLogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const CustomLogoutDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Lebih smooth
      ),
      titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      actionsPadding: const EdgeInsets.only(bottom: 16, right: 16),
      title: const Row(
        children: [
          Icon(Icons.logout, color: Colors.red, size: 28),
          SizedBox(width: 12), // Beri jarak lebih nyaman
          Expanded(
            child: Text(
              "Konfirmasi Logout",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      content: const Text(
        "Apakah Anda yakin ingin keluar?",
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey,
            textStyle: const TextStyle(fontSize: 16),
          ),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Tutup dialog
            onConfirm(); // Eksekusi logout
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            textStyle: const TextStyle(fontSize: 16),
          ),
          child: const Text("Keluar"),
        ),
      ],
    );
  }
}

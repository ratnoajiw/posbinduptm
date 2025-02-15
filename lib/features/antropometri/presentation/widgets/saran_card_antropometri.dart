import 'package:flutter/material.dart';

class SaranCardAntropometri extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> saran;
  final Color color;
  const SaranCardAntropometri(
      {super.key,
      required this.icon,
      required this.title,
      required this.saran,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Divider(),
          ...saran.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text("• $item", style: const TextStyle(fontSize: 14)),
              )),
        ],
      ),
    );
  }
}

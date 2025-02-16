import 'package:flutter/material.dart';
import 'package:posbinduptm/core/utils/format_date.dart';
import 'package:posbinduptm/core/utils/format_number.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/periksa_gula_darah_entity.dart';
import 'package:posbinduptm/features/periksa_gula_darah/presentation/pages/update_gula_darah_page.dart';

class GulaDarahCard extends StatelessWidget {
  final PeriksaGulaDarahEntity gulaDarah;
  final VoidCallback onDelete;
  final Color color;

  const GulaDarahCard({
    super.key,
    required this.gulaDarah,
    required this.onDelete,
    required this.color,
  });

  // **Fungsi menentukan warna berdasarkan klasifikasi WHO/Kemenkes**
  Color _getStatusColor(double gulaDarah) {
    if (gulaDarah <= 140) return Colors.green;
    if (gulaDarah > 140 && gulaDarah <= 200) return Colors.orange;
    return Colors.red;
  }

  // **Fungsi menentukan status kesehatan berdasarkan gula darah**
  String _getStatusText(double gulaDarah) {
    if (gulaDarah <= 140) return "Normal";
    if (gulaDarah > 140 && gulaDarah <= 200) return "Pra-diabetes";
    return "Diabetes";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: color,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **Tanggal Pemeriksaan**
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Pemeriksaan: ${formatDateBydMMMMYYYY(gulaDarah.pemeriksaanAt)}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(
              color: color,
            ),
            // **Data Gula Darah**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // **Label & Nilai Gula Darah**
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Gula Darah",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    Text(
                      "${formatNumber(gulaDarah.gulaDarahSewaktu)} mg/dL",
                      style: TextStyle(
                        fontSize: 24, // **Diperbesar**
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(gulaDarah.gulaDarahSewaktu),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(gulaDarah.gulaDarahSewaktu),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getStatusText(gulaDarah
                            .gulaDarahSewaktu), // **Menampilkan status kesehatan**
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                // **Aksi Edit & Delete**
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateGulaDarahPage(
                              id: gulaDarah.id,
                              gulaDarahSewaktuId: gulaDarah.gulaDarahSewaktu,
                              pemeriksaanAt: gulaDarah.pemeriksaanAt,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_outlined,
                          color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

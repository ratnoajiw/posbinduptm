import 'package:flutter/material.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/core/utils/format_date.dart';
import 'package:posbinduptm/core/utils/format_number.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/entities/tekanan_darah_entity.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/presentation/pages/update_tekanan_darah_page.dart';

class TekananDarahCard extends StatelessWidget {
  final TekananDarahEntity tekananDarah;
  final VoidCallback onDelete;
  final Color color;

  const TekananDarahCard({
    super.key,
    required this.tekananDarah,
    required this.onDelete,
    required this.color,
  });

  // **Fungsi menentukan warna berdasarkan klasifikasi tekanan darah**
  Color _getStatusColor(double sistolik, double diastolik) {
    if (sistolik < 120 && diastolik < 80) {
      return Colors.green;
    } else if (sistolik >= 120 && sistolik <= 129 && diastolik < 80) {
      return Colors.orange;
    } else if ((sistolik >= 130 && sistolik <= 139) ||
        (diastolik >= 80 && diastolik <= 89)) {
      return AppPallete.gradientRed3; // Hipertensi Tingkat 1
    } else if (sistolik >= 140 && sistolik <= 180 ||
        diastolik >= 90 && diastolik <= 120) {
      return AppPallete.gradientRed2; // Hipertensi Tingkat 2
    } else {
      return AppPallete.gradientRed1; // Krisis Hipertensi atau lebih tinggi
    }
  }

  // **Fungsi menentukan status kesehatan berdasarkan tekanan darah**
  String _getStatusText(double sistolik, double diastolik) {
    if (sistolik < 120 && diastolik < 80) {
      return "Normal";
    } else if (sistolik >= 120 && sistolik <= 129 && diastolik < 80) {
      return "Meningkat";
    } else if ((sistolik >= 130 && sistolik <= 139) ||
        (diastolik >= 80 && diastolik <= 89)) {
      return "Hipertensi Tingkat 1";
    } else if (sistolik >= 140 && sistolik <= 180 ||
        diastolik >= 90 && diastolik <= 120) {
      return "Hipertensi Tingkat 2";
    } else {
      return "Krisis Hipertensi!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: color,
          width: 1.5,
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Pemeriksaan: ${formatDateBydMMMMYYYY(tekananDarah.pemeriksaanAt)}",
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
            // **Data Tekanan Darah**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // **Label & Nilai Tekanan Darah**

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sistolik/Diastolik",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    Row(
                      children: [
                        Text(
                          "${formatNumber(tekananDarah.sistolik)}/",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(
                                tekananDarah.sistolik, tekananDarah.diastolik),
                          ),
                        ),
                        Text(
                          "${formatNumber(tekananDarah.diastolik)} mmHg",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(
                                tekananDarah.sistolik, tekananDarah.diastolik),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                                tekananDarah.sistolik, tekananDarah.diastolik)
                            .withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getStatusText(
                            tekananDarah.sistolik, tekananDarah.diastolik),
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
                            builder: (context) => UpdateTekananDarahPage(
                              tekananDarahId: tekananDarah.tekananDarahId,
                              sistolik: tekananDarah.sistolik,
                              diastolik: tekananDarah.diastolik,
                              pemeriksaanAt: tekananDarah.pemeriksaanAt,
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

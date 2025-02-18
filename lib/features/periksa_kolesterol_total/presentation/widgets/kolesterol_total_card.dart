import 'package:flutter/material.dart';
import 'package:posbinduptm/core/utils/format_date.dart';
import 'package:posbinduptm/core/utils/format_number.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/entities/kolesterol_total_entity.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/presentation/pages/update_kolesterol_total_page.dart';

class KolesterolTotalCard extends StatelessWidget {
  final KolesterolTotalEntity kolesterolTotal;
  final VoidCallback onDelete;
  final Color color;

  const KolesterolTotalCard({
    super.key,
    required this.kolesterolTotal,
    required this.onDelete,
    required this.color,
  });

  // **Fungsi menentukan warna berdasarkan klasifikasi kolesterol total**
  Color _getStatusColor(double kolesterolTotal) {
    if (kolesterolTotal < 200) {
      return Colors.green;
    } else if (kolesterolTotal >= 200 && kolesterolTotal <= 239) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // **Fungsi menentukan status kesehatan berdasarkan kolesterol total**
  String _getStatusText(double kolesterolTotal) {
    if (kolesterolTotal < 200) {
      return "Normal";
    } else if (kolesterolTotal >= 200 && kolesterolTotal <= 239) {
      return "Batas Tinggi";
    } else {
      return "Tinggi";
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
                "Pemeriksaan: ${formatDateBydMMMMYYYY(kolesterolTotal.pemeriksaanAt)}",
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
            // **Data Kolesterol Total**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // **Label & Nilai Kolesterol Total**
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Kolesterol Total",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    Text(
                      "${formatNumber(kolesterolTotal.kolesterolTotal)} mg/dL",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(kolesterolTotal.kolesterolTotal),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(kolesterolTotal.kolesterolTotal)
                            .withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getStatusText(kolesterolTotal.kolesterolTotal),
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
                            builder: (context) => UpdateKolesterolTotalPage(
                              kolesterolTotalId:
                                  kolesterolTotal.kolesterolTotalId,
                              kolesterolTotal: kolesterolTotal.kolesterolTotal,
                              pemeriksaanAt: kolesterolTotal.pemeriksaanAt,
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

import 'package:flutter/material.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/core/utils/format_date.dart';
import 'package:posbinduptm/core/utils/format_number.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/entities/kolesterol_total_entity.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/presentation/pages/chart_kolesterol_total_page.dart';

class DetailKolesterolTotalPage extends StatelessWidget {
  final KolesterolTotalEntity kolesterolTotal;

  const DetailKolesterolTotalPage({super.key, required this.kolesterolTotal});

  @override
  Widget build(BuildContext context) {
    // Variabel saran berdasarkan kolesterol total
    Map<String, List<String>> saranKolesterolTotal =
        _getSaranKolesterolTotal(kolesterolTotal.kolesterolTotal);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Pemeriksaan",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tanggal pemeriksaan
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(kolesterolTotal.kolesterolTotal)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Pemeriksaan: ${formatDateBydMMMMYYYY(kolesterolTotal.pemeriksaanAt)}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(kolesterolTotal.kolesterolTotal),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Hasil pemeriksaan
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    _buildDetailItem("Kolesterol Total",
                        "${formatNumber(kolesterolTotal.kolesterolTotal)} mg/dL"),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Status kolesterol total
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(kolesterolTotal.kolesterolTotal)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color:
                            _getStatusColor(kolesterolTotal.kolesterolTotal)),
                    const SizedBox(width: 10),
                    Text(
                      "Status: ${_getStatusText(kolesterolTotal.kolesterolTotal)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(kolesterolTotal.kolesterolTotal),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Saran
              Column(
                children: [
                  _buildSaranCard(
                    icon: Icons.check_circle_outline,
                    title: "Yang Perlu Dilakukan",
                    saran: saranKolesterolTotal["Lakukan"]!,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  _buildSaranCard(
                    icon: Icons.warning_amber_outlined,
                    title: "Yang Harus Dihindari",
                    saran: saranKolesterolTotal["Hindari"]!,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Tombol lihat grafik perkembangan
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, KolesterolTotalChartPage.route());
                  },
                  child: const Text(
                    "Lihat Grafik Perkembangan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          Text(value,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSaranCard({
    required IconData icon,
    required String title,
    required List<String> saran,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
          const Divider(),
          for (String item in saran)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: Colors.black),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(item, style: const TextStyle(fontSize: 14))),
                ],
              ),
            ),
        ],
      ),
    );
  }

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

  Map<String, List<String>> _getSaranKolesterolTotal(double kolesterolTotal) {
    if (kolesterolTotal < 200) {
      return {
        "Lakukan": [
          "Pertahankan gaya hidup sehat: gizi seimbang, olahraga teratur",
          "Konsumsi makanan yang baik untuk jantung (sayur, buah, ikan)",
          "Rutin periksakan kolesterol total"
        ],
        "Hindari": [
          "Makanan tinggi lemak jenuh dan kolesterol (daging berlemak, gorengan)",
          "Kurang aktivitas fisik",
          "Merokok dan konsumsi alkohol"
        ]
      };
    } else if (kolesterolTotal >= 200 && kolesterolTotal <= 239) {
      return {
        "Lakukan": [
          "Modifikasi gaya hidup: kurangi asupan lemak jenuh dan kolesterol",
          "Tingkatkan aktivitas fisik",
          "Periksa kolesterol total secara berkala"
        ],
        "Hindari": [
          "Makanan cepat saji",
          "Makanan olahan tinggi lemak",
          "Stres berlebihan"
        ]
      };
    } else {
      return {
        "Lakukan": [
          "Konsultasi dengan dokter untuk penanganan lebih lanjut",
          "Terapkan diet rendah lemak dan kolesterol",
          "Rutin berolahraga"
        ],
        "Hindari": [
          "Makanan tinggi lemak jenuh dan kolesterol",
          "Kurang aktivitas fisik",
          "Merokok dan konsumsi alkohol"
        ]
      };
    }
  }
}

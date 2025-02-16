import 'package:flutter/material.dart';
import 'package:posbinduptm/core/utils/format_date.dart';
import 'package:posbinduptm/core/utils/format_number.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/periksa_gula_darah_entity.dart';
import 'package:posbinduptm/features/periksa_gula_darah/presentation/pages/chart_gula_darah_page.dart';

class DetailGulaDarahPage extends StatelessWidget {
  final PeriksaGulaDarahEntity gulaDarah;

  const DetailGulaDarahPage({super.key, required this.gulaDarah});

  @override
  Widget build(BuildContext context) {
    // Variabel saran berdasarkan kadar gula darah
    Map<String, List<String>> saranGulaDarah =
        _getSaranGulaDarah(gulaDarah.gulaDarahSewaktu);

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
                  color: _getGulaDarahColor(gulaDarah.gulaDarahSewaktu)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Pemeriksaan: ${formatDateBydMMMMYYYY(gulaDarah.pemeriksaanAt)}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _getGulaDarahColor(gulaDarah.gulaDarahSewaktu),
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
                child: _buildDetailItem("Gula Darah Sewaktu",
                    "${formatNumber(gulaDarah.gulaDarahSewaktu)} mg/dL"),
              ),
              const SizedBox(height: 10),

              // Status gula darah
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getGulaDarahColor(gulaDarah.gulaDarahSewaktu)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: _getGulaDarahColor(gulaDarah.gulaDarahSewaktu)),
                    const SizedBox(width: 10),
                    Text(
                      "Status: ${_getGulaDarahCategory(gulaDarah.gulaDarahSewaktu)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _getGulaDarahColor(gulaDarah.gulaDarahSewaktu),
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
                    saran: saranGulaDarah["Lakukan"]!,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  _buildSaranCard(
                    icon: Icons.warning_amber_outlined,
                    title: "Yang Harus Dihindari",
                    saran: saranGulaDarah["Hindari"]!,
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
                    Navigator.push(context, ChartGulaDarahPage.route());
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
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: color),
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

  Color _getGulaDarahColor(double gulaDarah) {
    if (gulaDarah <= 140) return Colors.green;
    if (gulaDarah > 140 && gulaDarah <= 200) return Colors.orange;
    return Colors.red;
  }

  String _getGulaDarahCategory(double gulaDarah) {
    if (gulaDarah <= 140) return "Normal";
    if (gulaDarah > 140 && gulaDarah <= 200) return "Pra-diabetes";
    return "Diabetes";
  }

  Map<String, List<String>> _getSaranGulaDarah(double gulaDarah) {
    if (gulaDarah <= 140) {
      return {
        "Lakukan": [
          "Jaga pola makan sehat",
          "Olahraga secara teratur",
          "Kendalikan stres"
        ],
        "Hindari": [
          "Makan berlebihan",
          "Kurang aktivitas fisik",
          "Konsumsi gula berlebih"
        ]
      };
    } else if (gulaDarah > 140 && gulaDarah <= 200) {
      return {
        "Lakukan": [
          "Kurangi konsumsi makanan tinggi gula",
          "Perbanyak serat dan sayuran",
          "Rutin berolahraga"
        ],
        "Hindari": [
          "Minuman manis",
          "Makanan olahan tinggi gula",
          "Kurang tidur"
        ]
      };
    } else {
      return {
        "Lakukan": [
          "Konsultasi dengan dokter",
          "Kendalikan pola makan",
          "Lakukan olahraga sesuai anjuran"
        ],
        "Hindari": [
          "Makanan tinggi gula dan karbohidrat sederhana",
          "Kurang aktivitas fisik",
          "Merokok dan alkohol"
        ]
      };
    }
  }
}

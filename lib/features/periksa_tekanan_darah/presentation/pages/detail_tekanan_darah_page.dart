import 'package:flutter/material.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/core/utils/format_date.dart';
import 'package:posbinduptm/core/utils/format_number.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/entities/tekanan_darah_entity.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/presentation/pages/chart_tekanan_darah_page.dart';

class DetailTekananDarahPage extends StatelessWidget {
  final TekananDarahEntity tekananDarah;

  const DetailTekananDarahPage({super.key, required this.tekananDarah});

  @override
  Widget build(BuildContext context) {
    // Variabel saran berdasarkan tekanan darah
    Map<String, List<String>> saranTekananDarah =
        _getSaranTekananDarah(tekananDarah.sistolik, tekananDarah.diastolik);

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
                  color: _getTekananDarahColor(
                          tekananDarah.sistolik, tekananDarah.diastolik)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Pemeriksaan: ${formatDateBydMMMMYYYY(tekananDarah.pemeriksaanAt)}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _getTekananDarahColor(
                        tekananDarah.sistolik, tekananDarah.diastolik),
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
                    _buildDetailItem("Sistolik",
                        "${formatNumber(tekananDarah.sistolik)} mmHg"),
                    _buildDetailItem("Diastolik",
                        "${formatNumber(tekananDarah.diastolik)} mmHg"),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Status tekanan darah
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getTekananDarahColor(
                          tekananDarah.sistolik, tekananDarah.diastolik)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: _getTekananDarahColor(
                            tekananDarah.sistolik, tekananDarah.diastolik)),
                    const SizedBox(width: 10),
                    Text(
                      "Status: ${_getTekananDarahCategory(tekananDarah.sistolik, tekananDarah.diastolik)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _getTekananDarahColor(
                            tekananDarah.sistolik, tekananDarah.diastolik),
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
                    saran: saranTekananDarah["Lakukan"]!,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  _buildSaranCard(
                    icon: Icons.warning_amber_outlined,
                    title: "Yang Harus Dihindari",
                    saran: saranTekananDarah["Hindari"]!,
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
                    Navigator.push(context, ChartTekananDarahPage.route());
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

  Color _getTekananDarahColor(double sistolik, double diastolik) {
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

  String _getTekananDarahCategory(double sistolik, double diastolik) {
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
      return "Krisis Hipertensi!\nSegera cari pertolongan medis terdekat.";
    }
  }

  Map<String, List<String>> _getSaranTekananDarah(
      double sistolik, double diastolik) {
    if (sistolik < 120 && diastolik < 80) {
      return {
        "Lakukan": [
          "Pertahankan gaya hidup sehat: gizi seimbang, olahraga teratur",
          "Konsumsi makanan yang baik untuk tekanan darah (sayur, buah)",
          "Rutin periksakan tekanan darah"
        ],
        "Hindari": [
          "Makanan tinggi garam, makanan cepat saji, makanan kaleng",
          "Kurang aktivitas fisik",
          "Merokok dan konsumsi alkohol"
        ]
      };
    } else if (sistolik >= 120 && sistolik <= 129 && diastolik < 80) {
      return {
        "Lakukan": [
          "Pantau tekanan darah secara berkala",
          "Modifikasi gaya hidup: kurangi asupan garam, olahraga",
          "Menurunkan berat badan jika obesitas (setiap penurunan 1kg, TD berkurang 1mmHg)]"
        ],
        "Hindari": [
          "Stres berlebihan",
          "Makanan olahan tinggi natrium",
          "Kurang tidur (dapat meningkatkan *sleep apnea*)"
        ]
      };
    } else if ((sistolik >= 130 && sistolik <= 139) ||
        (diastolik >= 80 && diastolik <= 89)) {
      return {
        "Lakukan": [
          "Konsultasi dengan dokter untuk penanganan lebih lanjut",
          "Periksa tekanan darah secara rutin",
          "Terapkan pola makan gizi seimbang, batasi gula, garam, dan lemak"
        ],
        "Hindari": [
          "Makanan cepat saji",
          "Minuman berkafein berlebihan",
          "Kurang olahraga"
        ]
      };
    } else if (sistolik >= 140 && sistolik <= 180 ||
        diastolik >= 90 && diastolik <= 120) {
      return {
        "Lakukan": [
          "Minum obat hipertensi sesuai resep dokter",
          "Periksa tekanan darah secara rutin",
          "Batasi asupan garam (< 1 sendok teh per hari)",
          "Rutin berolahraga (jalan kaki 30-45 menit, 5x seminggu)"
        ],
        "Hindari": [
          "Melewatkan minum obat",
          "Makanan tinggi garam dan lemak",
          "Stres berlebihan"
        ]
      };
    } else {
      return {
        "Lakukan": [
          "Segera cari pertolongan medis",
          "Istirahat total",
          "Minum obat sesuai anjuran dokter"
        ],
        "Hindari": [
          "Aktivitas fisik berat",
          "Stres berlebihan",
          "Makanan tinggi garam dan lemak"
        ]
      };
    }
  }
}

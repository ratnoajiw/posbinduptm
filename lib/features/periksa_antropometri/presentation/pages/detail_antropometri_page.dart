import 'package:flutter/material.dart';
import 'package:posbinduptm/core/utils/format_date.dart';
import 'package:posbinduptm/core/utils/format_number.dart';
import 'package:posbinduptm/features/periksa_antropometri/domain/entities/antropometri_entity.dart';
import 'package:posbinduptm/features/periksa_antropometri/presentation/pages/chart_antropometri_page.dart';
import 'package:posbinduptm/features/periksa_antropometri/presentation/widgets/saran_card_antropometri.dart';

class DetailAntropometriPage extends StatelessWidget {
  final AntropometriEntity antropometri;

  const DetailAntropometriPage({super.key, required this.antropometri});

  @override
  Widget build(BuildContext context) {
    //variabel saranIMT menampung data berdasarkan IMT pasien
    Map<String, List<String>> saranIMT = _getSaranIMT(antropometri.imtPasien);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pemeriksaan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // tanggal pemeriksaan
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getIMTColor(antropometri.imtPasien).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Pemeriksaan: ${formatDateBydMMMMYYYY(antropometri.pemeriksaanAt)}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _getIMTColor(antropometri.imtPasien),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              //hasil pemeriksaan
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem("Tinggi Badan",
                        "${formatNumber(antropometri.tinggiBadan)} cm"),
                    _buildDetailItem("Berat Badan",
                        "${formatNumber(antropometri.beratBadan)} kg"),
                    _buildDetailItem("Lingkar Perut",
                        "${formatNumber(antropometri.lingkarPerut)} cm"),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              //status IMT
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getIMTColor(antropometri.imtPasien).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: _getIMTColor(antropometri.imtPasien)),
                    const SizedBox(width: 10),
                    Text(
                      "Status IMT: ${_getIMTCategory(antropometri.imtPasien)}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _getIMTColor(antropometri.imtPasien)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              //card saran
              Column(
                children: [
                  SaranCardAntropometri(
                    icon: Icons.check_circle_outline,
                    title: "Yang Perlu Dilakukan",
                    saran: saranIMT["Lakukan"]!,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  SaranCardAntropometri(
                    icon: Icons.warning_amber_outlined,
                    title: "Yang Harus Dihindari",
                    saran: saranIMT["Hindari"]!,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              //tombol lihat grafik perkembangan
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
                    Navigator.push(context, ChartAntropometriPage.route());
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

  Color _getIMTColor(double imt) {
    if (imt < 18.5) return Colors.blue;
    if (imt >= 18.5 && imt < 25.0) return Colors.green;
    if (imt >= 25.0 && imt < 30.0) return Colors.orange;
    return Colors.red;
  }

  String _getIMTCategory(double imt) {
    if (imt < 18.5) return "Berat Badan Kurang";
    if (imt >= 18.5 && imt < 25.0) return "Ideal";
    if (imt >= 25.0 && imt < 30.0) return "Berat Badan Lebih";
    return "Obesitas";
  }

  Map<String, List<String>> _getSaranIMT(double imt) {
    if (imt < 18.5) {
      return {
        "Lakukan": [
          "Makan lebih banyak dengan gizi seimbang",
          "Konsumsi protein tinggi",
          "Olahraga ringan secara rutin"
        ],
        "Hindari": ["Melewatkan makan", "Makanan cepat saji", "Kurang tidur"]
      };
    } else if (imt >= 18.5 && imt < 25) {
      return {
        "Lakukan": [
          "Jaga pola makan sehat",
          "Olahraga teratur",
          "Cukup istirahat"
        ],
        "Hindari": [
          "Stres berlebihan",
          "Kurang aktivitas fisik",
          "Makan berlebihan"
        ]
      };
    } else if (imt >= 25 && imt < 30) {
      return {
        "Lakukan": [
          "Kurangi makanan berlemak",
          "Perbanyak serat dan sayuran",
          "Rutin berolahraga"
        ],
        "Hindari": ["Fast food", "Minuman manis", "Makan larut malam"]
      };
    } else {
      return {
        "Lakukan": [
          "Kendalikan porsi makan",
          "Tingkatkan aktivitas fisik",
          "Konsultasi dokter atau ahli gizi"
        ],
        "Hindari": [
          "Makanan tinggi kalori",
          "Kurang tidur",
          "Minuman bersoda dan manis"
        ]
      };
    }
  }
}

import 'package:flutter/material.dart';
import 'package:posbinduptm/core/utils/format_date.dart';
import 'package:posbinduptm/core/utils/format_number.dart';
import 'package:posbinduptm/features/antropometri/domain/entities/antropometri_entity.dart';
import 'package:posbinduptm/features/antropometri/presentation/pages/antropometri_chart_page.dart';

class DetailAntropometriPage extends StatelessWidget {
  final AntropometriEntity antropometri;

  const DetailAntropometriPage({super.key, required this.antropometri});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pemeriksaan"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleCard(context),
              const SizedBox(height: 12),
              _buildDetailSection(),
              const SizedBox(height: 16),
              _buildStatusCard(),
              const SizedBox(height: 16),
              _buildSaranSection(),
              const SizedBox(height: 16),
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
                    Navigator.push(context, AntropometriChartPage.route());
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

  Widget _buildTitleCard(BuildContext context) {
    Color color = _getIMTColor(antropometri.imtPasien);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "Pemeriksaan: ${formatDateBydMMMMYYYY(antropometri.pemeriksaanAt)}",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDetailSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem(
              "Tinggi Badan", "${formatNumber(antropometri.tinggiBadan)} cm"),
          _buildDetailItem(
              "Berat Badan", "${formatNumber(antropometri.beratBadan)} kg"),
          _buildDetailItem(
              "Lingkar Perut", "${formatNumber(antropometri.lingkarPerut)} cm"),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 14, color: Colors.black87)),
          Text(value,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    Color color = _getIMTColor(antropometri.imtPasien);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: color),
          const SizedBox(width: 10),
          Text(
            "Status IMT: ${_getIMTCategory(antropometri.imtPasien)}",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildSaranSection() {
    Map<String, List<String>> saranIMT = _getSaranIMT(antropometri.imtPasien);
    return Column(
      children: [
        _buildSaranCard(Icons.check_circle_outline, "Yang Perlu Dilakukan",
            saranIMT["Lakukan"]!, Colors.green),
        const SizedBox(height: 10),
        _buildSaranCard(Icons.warning_amber_outlined, "Yang Harus Dihindari",
            saranIMT["Hindari"]!, Colors.red),
      ],
    );
  }

  Widget _buildSaranCard(
    IconData icon,
    String title,
    List<String> saran,
    Color color,
  ) {
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

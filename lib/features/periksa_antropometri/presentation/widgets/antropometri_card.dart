import 'package:flutter/material.dart';
import 'package:posbinduptm/core/utils/format_date.dart';
import 'package:posbinduptm/core/utils/format_number.dart';
import 'package:posbinduptm/features/periksa_antropometri/domain/entities/antropometri_entity.dart';
import 'package:posbinduptm/features/periksa_antropometri/presentation/pages/update_antropometri_page.dart';

class AntropometriCard extends StatelessWidget {
  final AntropometriEntity antropometri;
  final VoidCallback onDelete;
  final Color color; // Warna outline dinamis

  const AntropometriCard({
    super.key,
    required this.antropometri,
    required this.onDelete,
    required this.color,
  });

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: color.withOpacity(0.8),
          width: 1.5, // Lebar border
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
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // tanggal pemeriksaan
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Pemeriksaan: ${formatDateBydMMMMYYYY(antropometri.pemeriksaanAt)}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Warna teks mengikuti outline
                  ),
                ),
              ),
              const Divider(),
              // data antropometri
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "📏 Tinggi Badan: ${formatNumber(antropometri.tinggiBadan)} cm"),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                          "⚖️ Berat Badan: ${formatNumber(antropometri.beratBadan)} kg"),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                          "📐 Lingkar Perut: ${formatNumber(antropometri.lingkarPerut)} cm"),
                      const SizedBox(
                        height: 5,
                      ),
                      // kategori IMT
                      Row(
                        children: [
                          Text(
                            "📊 IMT: ${antropometri.imtPasien.toStringAsFixed(2)}  ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getIMTColor(antropometri.imtPasien),
                              fontSize: 14, // Ukuran Font Disamakan
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getIMTColor(antropometri.imtPasien)
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getIMTCategory(antropometri.imtPasien),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getIMTColor(antropometri.imtPasien),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // **Aksi Edit & Delete**
                  Column(
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.edit_outlined, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateAntropometriPage(
                                id: antropometri.id,
                                tinggiBadan: antropometri.tinggiBadan,
                                beratBadan: antropometri.beratBadan,
                                lingkarPerut: antropometri.lingkarPerut,
                                pemeriksaanAt: antropometri.pemeriksaanAt,
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
      ),
    );
  }
}

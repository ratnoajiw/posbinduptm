import 'package:flutter/material.dart';
import 'package:posbinduptm/core/utils/format_date.dart';
import 'package:posbinduptm/features/antropometri/domain/entities/antropometri_entity.dart';
import 'package:posbinduptm/features/antropometri/presentation/pages/edit_antropometri_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: color, // Warna outline mengikuti parameter
          width: 2,
        ),
        borderRadius:
            BorderRadius.circular(12), // Sama dengan Card agar tidak aneh
      ),
      child: Card(
        elevation: 4, // Tambahkan shadow agar lebih menarik
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // **Judul Pemeriksaan**
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      color.withOpacity(0.2), // Warna latar belakang transparan
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Pemeriksaan: ${formatDateBydMMMYYYY(antropometri.updatedAt)}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color, // Warna teks mengikuti outline
                  ),
                ),
              ),

              Divider(
                color: color,
              ),

              // **Data Antropometri**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDataRow(
                          "📏 Tinggi Badan", "${antropometri.tinggiBadan} cm"),
                      _buildDataRow(
                          "⚖️ Berat Badan", "${antropometri.beratBadan} kg"),
                      _buildDataRow("📐 Lingkar Perut",
                          "${antropometri.lingkarPerut} cm"),

                      // **IMT + Kategorinya**
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
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditAntropometriPage(
                                id: antropometri.id,
                                tinggiBadan: antropometri.tinggiBadan,
                                beratBadan: antropometri.beratBadan,
                                lingkarPerut: antropometri.lingkarPerut,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
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

  // Fungsi untuk membuat baris data dengan padding konsisten
  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        "$label: $value",
        style: const TextStyle(fontSize: 14, color: Colors.black87),
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
    if (imt >= 18.5 && imt < 25.0) return "Normal";
    if (imt >= 25.0 && imt < 30.0) return "Berat Badan Lebih";
    return "Obesitas";
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/features/periksa_antropometri/domain/entities/antropometri_entity.dart';

class AntropometriChart extends StatelessWidget {
  final List<AntropometriEntity> data;

  const AntropometriChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Ambil tanggal sekarang
    final DateTime now = DateTime.now();

    // Ambil 6 bulan terakhir
    List<String> monthLabels = List.generate(6, (index) {
      DateTime month = DateTime(now.year, now.month - index, 1);
      return DateFormat('MMM').format(month);
    }).reversed.toList(); // Urutan dari bulan lama ke baru

    // Buat default map untuk berat badan
    Map<String, double> weightMap = {for (var month in monthLabels) month: 0.0};

    // Isi data dari entri yang tersedia
    for (var entry in data) {
      String monthKey = DateFormat('MMM').format(entry.pemeriksaanAt);
      if (weightMap.containsKey(monthKey)) {
        weightMap[monthKey] = entry.beratBadan.toDouble();
      }
    }

    // Konversi data ke daftar FlSpot
    List<FlSpot> spots = [];
    for (int i = 0; i < monthLabels.length; i++) {
      spots.add(FlSpot(i.toDouble(), weightMap[monthLabels[i]]!));
    }

    // Tentukan rentang berat badan (Y Axis)
    double minWeight = weightMap.values.reduce((a, b) => a < b ? a : b);
    double maxWeight = weightMap.values.reduce((a, b) => a > b ? a : b);
    minWeight = (minWeight / 5).floor() * 5.0;
    maxWeight = (maxWeight / 5).ceil() * 5.0;

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 300,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: monthLabels.length - 1,
            minY: minWeight,
            maxY: maxWeight,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  getTitlesWidget: (value, meta) => Text("${value.toInt()} kg"),
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < monthLabels.length) {
                      return Transform.translate(
                        offset: const Offset(0, 5),
                        child: Text(
                          monthLabels[index],
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const Text("");
                  },
                ),
              ),
            ),
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: false,
                color: AppPallete.gradientGreen3,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
                barWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

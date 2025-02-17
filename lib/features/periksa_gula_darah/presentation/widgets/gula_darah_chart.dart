import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/gula_darah_entity.dart';

class GulaDarahChart extends StatelessWidget {
  final List<GulaDarahEntity> data;

  const GulaDarahChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    //ambil tanggal sekarang
    final DateTime now = DateTime.now();

    // Ambil 6 bulan terakhir
    List<String> monthLabels = List.generate(6, (index) {
      DateTime month = DateTime(now.year, now.month - index, 1);
      return DateFormat('MMM').format(month);
    }).reversed.toList();

    // Buat default map untuk gula darah sewaktu
    Map<String, double> gulaDarahMap = {
      for (var month in monthLabels) month: 0.0
    };

    // Isi data dari entri yang tersedia
    for (var entry in data) {
      String monthKey = DateFormat('MMM').format(entry.pemeriksaanAt);
      if (gulaDarahMap.containsKey(monthKey)) {
        gulaDarahMap[monthKey] = entry.gulaDarahSewaktu.toDouble();
      }
    }

    // Konversi data ke daftar FlSpot
    List<FlSpot> spots = [];
    for (int i = 0; i < monthLabels.length; i++) {
      spots.add(FlSpot(i.toDouble(), gulaDarahMap[monthLabels[i]]!));
    }

    // Tentukan rentang Y Axis (kadar gula darah)
    double minGula = gulaDarahMap.values.reduce((a, b) => a < b ? a : b);
    double maxGula = gulaDarahMap.values.reduce((a, b) => a > b ? a : b);
    minGula = (minGula / 10).floor() * 10.0;
    maxGula = (maxGula / 10).ceil() * 10.0;

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 300,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: monthLabels.length - 1,
            minY: minGula,
            maxY: maxGula,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 80,
                  getTitlesWidget: (value, meta) =>
                      Text("${value.toInt()} mg/dL"),
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
                color: AppPallete.gradientGreen1,
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

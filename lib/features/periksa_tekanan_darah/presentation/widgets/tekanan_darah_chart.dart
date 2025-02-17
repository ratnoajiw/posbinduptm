import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/entities/tekanan_darah_entity.dart';

class TekananDarahChart extends StatelessWidget {
  final List<TekananDarahEntity> data;

  const TekananDarahChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Ambil tanggal sekarang
    final DateTime now = DateTime.now();

    // Ambil 6 bulan terakhir
    List<String> monthLabels = List.generate(6, (index) {
      DateTime month = DateTime(now.year, now.month - index, 1);
      return DateFormat('MMM').format(month);
    }).reversed.toList();

    // Buat default map untuk sistolik dan diastolik
    Map<String, double> sistolikMap = {
      for (var month in monthLabels) month: 0.0
    };
    Map<String, double> diastolikMap = {
      for (var month in monthLabels) month: 0.0
    };

    // Isi data dari entri yang tersedia
    for (var entry in data) {
      String monthKey = DateFormat('MMM').format(entry.pemeriksaanAt);
      if (sistolikMap.containsKey(monthKey)) {
        sistolikMap[monthKey] = entry.sistolik.toDouble();
        diastolikMap[monthKey] = entry.diastolik.toDouble();
      }
    }

    // Konversi data ke daftar FlSpot untuk sistolik dan diastolik
    List<FlSpot> sistolikSpots = [];
    List<FlSpot> diastolikSpots = [];
    for (int i = 0; i < monthLabels.length; i++) {
      sistolikSpots.add(FlSpot(i.toDouble(), sistolikMap[monthLabels[i]]!));
      diastolikSpots.add(FlSpot(i.toDouble(), diastolikMap[monthLabels[i]]!));
    }

    // Tentukan rentang Y Axis (tekanan darah)
    double minTekanan = [
      sistolikMap.values.reduce((a, b) => a < b ? a : b),
      diastolikMap.values.reduce((a, b) => a < b ? a : b)
    ].reduce((a, b) => a < b ? a : b);

    double maxTekanan = [
      sistolikMap.values.reduce((a, b) => a > b ? a : b),
      diastolikMap.values.reduce((a, b) => a > b ? a : b)
    ].reduce((a, b) => a > b ? a : b);

    minTekanan = (minTekanan / 10).floor() * 10.0;
    maxTekanan = (maxTekanan / 10).ceil() * 10.0;

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 300,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: monthLabels.length - 1,
            minY: minTekanan,
            maxY: maxTekanan,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 80,
                  getTitlesWidget: (value, meta) =>
                      Text("${value.toInt()} mmHg"),
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
                spots: sistolikSpots,
                isCurved: false,
                color: AppPallete.gradientGreen1,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
                barWidth: 3,
              ),
              LineChartBarData(
                spots: diastolikSpots,
                isCurved: false,
                color: Colors.blue,
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

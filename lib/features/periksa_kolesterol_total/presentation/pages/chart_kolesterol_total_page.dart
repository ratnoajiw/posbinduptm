import 'package:flutter/material.dart';
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/entities/kolesterol_total_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/presentation/bloc/kolesterol_total_bloc.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/presentation/widgets/kolesterol_total_chart.dart';

class KolesterolTotalChartPage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const KolesterolTotalChartPage(),
      );

  const KolesterolTotalChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grafik Perkembangan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: BlocBuilder<KolesterolTotalBloc, KolesterolTotalState>(
        builder: (context, state) {
          if (state is KolesterolTotalLoading) {
            return const Loader();
          } else if (state is KolesterolTotalDisplaySuccess) {
            final List<KolesterolTotalEntity> data = state.kolesterolTotalList;

            if (data.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.show_chart, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "Belum ada data yang tersedia",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Silakan tambahkan data pemeriksaan kolesterol total terlebih dahulu.",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Grafik Kolesterol Total dalam 6 Bulan Terakhir",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Grafik ini menunjukkan perubahan kadar kolesterol total dalam beberapa bulan terakhir. Rutin lakukan pemeriksaan untuk memantau kondisi kesehatan Anda.",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          KolesterolTotalChart(
                              data:
                                  data), // Memanggil widget KolesterolTotalChart
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is KolesterolTotalFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 80, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    "Terjadi Kesalahan",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.error,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return const Loader();
        },
      ),
    );
  }
}

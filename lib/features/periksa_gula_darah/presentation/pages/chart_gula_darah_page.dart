import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/periksa_gula_darah_entity.dart';
import 'package:posbinduptm/features/periksa_gula_darah/presentation/bloc/periksa_gula_darah_bloc.dart';
import 'package:posbinduptm/features/periksa_gula_darah/presentation/widgets/gula_darah_chart.dart';

class ChartGulaDarahPage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const ChartGulaDarahPage(),
      );

  const ChartGulaDarahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grafik Perkembangan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: BlocBuilder<PeriksaGulaDarahBloc, PeriksaGulaDarahState>(
        builder: (context, state) {
          if (state is PeriksaGulaDarahLoading) {
            return const Loader();
          } else if (state is PeriksaGulaDarahDisplaySuccess) {
            final List<PeriksaGulaDarahEntity> data =
                state.periksaGulaDarahList;

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
                      "Silakan tambahkan data pemeriksaan gula darah terlebih dahulu.",
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
                            "Grafik Kadar Gula Darah dalam 6 Bulan Terakhir",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Grafik ini menunjukkan perubahan kadar gula darah sewaktu dalam beberapa bulan terakhir. Rutin lakukan pemeriksaan untuk memantau kondisi kesehatan Anda.",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          GulaDarahChart(data: data),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is PeriksaGulaDarahFailure) {
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

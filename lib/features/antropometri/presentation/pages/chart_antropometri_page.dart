import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/features/antropometri/domain/entities/antropometri_entity.dart';
import 'package:posbinduptm/features/antropometri/presentation/widgets/antropometri_chart.dart';
import 'package:posbinduptm/features/antropometri/presentation/bloc/antropometri_bloc.dart';
import 'package:posbinduptm/core/common/widgets/loader.dart';

class ChartAntropometriPage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const ChartAntropometriPage(),
      );

  const ChartAntropometriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grafik Perkembangan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: BlocBuilder<AntropometriBloc, AntropometriState>(
        builder: (context, state) {
          if (state is AntropometriLoading) {
            return const Loader();
          } else if (state is AntropometrisDisplaySuccess) {
            final List<AntropometriEntity> data = state.antropometriList;

            if (data.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "Belum ada data yang tersedia",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Silakan tambahkan data antropometri terlebih dahulu.",
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
                            "Grafik Berat Badan dalam 6 Bulan Terakhir",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Grafik ini menunjukkan perkembangan berat badan Anda dalam beberapa bulan terakhir. Pastikan untuk rutin memperbarui data agar dapat memantau perubahan dengan lebih baik.",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          AntropometriChart(data: data),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is AntropometriFailure) {
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

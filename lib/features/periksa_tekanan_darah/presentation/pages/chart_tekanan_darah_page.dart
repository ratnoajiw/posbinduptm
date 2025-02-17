import 'package:flutter/material.dart';
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/entities/tekanan_darah_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/presentation/bloc/tekanan_darah_bloc.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/presentation/widgets/tekanan_darah_chart.dart';

class ChartTekananDarahPage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const ChartTekananDarahPage(),
      );

  const ChartTekananDarahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grafik Perkembangan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: BlocBuilder<TekananDarahBloc, TekananDarahState>(
        builder: (context, state) {
          if (state is TekananDarahLoading) {
            return const Loader();
          } else if (state is TekananDarahDisplaySuccess) {
            final List<TekananDarahEntity> data = state.tekananDarahList;

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
                      "Silakan tambahkan data pemeriksaan tekanan darah terlebih dahulu.",
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
                            "Grafik Tekanan Darah dalam 6 Bulan Terakhir",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Grafik ini menunjukkan perubahan tekanan darah (sistolik dan diastolik) dalam beberapa bulan terakhir. Rutin lakukan pemeriksaan untuk memantau kondisi kesehatan Anda.",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          TekananDarahChart(
                              data: data), // Memanggil widget TekananDarahChart
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is TekananDarahFailure) {
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

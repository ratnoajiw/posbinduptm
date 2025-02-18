import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/features/pasien/presentation/bloc/pasien_bloc.dart';
import 'package:posbinduptm/features/pasien/presentation/pages/update_pasien_page.dart';
import 'package:posbinduptm/features/pasien/presentation/pages/upload_pasien_page.dart';

class DetailPasienPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const DetailPasienPage(),
      );

  const DetailPasienPage({super.key});

  @override
  State<DetailPasienPage> createState() => _DetailPasienPageState();
}

class _DetailPasienPageState extends State<DetailPasienPage> {
  @override
  void initState() {
    super.initState();
    // Panggil event untuk mendapatkan data pasien saat halaman diinisialisasi
    final state = context.read<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      final profileId = state.user.id;
      context.read<PasienBloc>().add(GetPasienEvent(profileId: profileId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil Saya", // Ubah judul AppBar
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<PasienBloc, PasienState>(
            builder: (context, state) {
              if (state is PasienLoaded && state.pasien != null) {
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UpdatePasienPage(pasien: state.pasien),
                      ),
                    );
                  },
                );
              }
              return const SizedBox
                  .shrink(); // Hilangkan tombol jika data belum di-load
            },
          ),
        ],
      ),
      body: BlocBuilder<PasienBloc, PasienState>(
        builder: (context, state) {
          if (state is PasienLoading) {
            return const Loader();
          } else if (state is PasienLoaded) {
            final pasien = state.pasien;

            if (pasien == null) {
              // Jika data pasien belum ada, arahkan ke halaman input
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Profil belum diisi',
                      style: TextStyle(fontSize: 18),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, UploadPasienPage.route());
                      },
                      child: const Text('Isi Profil Sekarang'),
                    ),
                  ],
                ),
              );
            }

            // Tampilkan detail profil jika data sudah ada
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailItem('NIK', pasien.nik),
                  BlocBuilder<AppUserCubit, AppUserState>(
                    builder: (context, appState) {
                      String userName = "-";
                      if (appState is AppUserLoggedIn) {
                        userName = appState.user.name ?? "-";
                      }
                      return _buildDetailItem('Nama', userName);
                    },
                  ),
                  _buildDetailItem('Jenis Kelamin',
                      pasien.jenisKelamin == 'L' ? 'Laki-laki' : 'Perempuan'),
                  _buildDetailItem(
                      'Tanggal Lahir',
                      pasien.tanggalLahir != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(pasien.tanggalLahir!)
                          : null),
                  _buildDetailItem('Alamat', pasien.alamat),
                  _buildDetailItem('Nomor HP', pasien.nomorHp),
                ],
              ),
            );
          } else if (state is PasienInitial) {
            return Container();
          } else {
            return const Center(child: Text('Terjadi kesalahan'));
          }
        },
      ),
    );
  }

  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value ?? '-',
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(), // Garis pemisah
        ],
      ),
    );
  }
}

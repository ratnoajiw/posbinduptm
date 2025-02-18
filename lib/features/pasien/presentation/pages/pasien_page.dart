import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/core/utils/custom_date_picker.dart';
import 'package:posbinduptm/core/utils/show_snackbar.dart';
import 'package:posbinduptm/features/pasien/domain/entities/pasien_entity.dart';
import 'package:posbinduptm/features/pasien/presentation/bloc/pasien_bloc.dart';

import '../widgets/pasien_field.dart';

class PasienPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const PasienPage(),
      );

  const PasienPage({super.key});

  @override
  State<PasienPage> createState() => _PasienPageState();
}

class _PasienPageState extends State<PasienPage> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  final _alamatController = TextEditingController();
  final _nomorHpController = TextEditingController();
  final _namaController = TextEditingController(); // Tambahkan controller nama

  String? _jenisKelamin;
  PasienEntity? pasien;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      final profileId = state.user.id;
      context.read<PasienBloc>().add(GetPasienEvent(profileId: profileId));
    }
  }

  @override
  void dispose() {
    _nikController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    _nomorHpController.dispose();
    _namaController.dispose(); // Dispose controller nama
    super.dispose();
  }

  Future<void> _pickTanggalLahir(BuildContext context) async {
    final String? selectedDate = await CustomDatePicker.pickDate(context);
    if (selectedDate != null) {
      setState(() {
        _tanggalLahirController.text = selectedDate;
      });
    }
  }

  void _submitForm(String profileId) {
    if (_formKey.currentState!.validate()) {
      final nik = _nikController.text.trim();
      final tanggalLahir = _tanggalLahirController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(_tanggalLahirController.text)
          : null;
      final alamat = _alamatController.text.trim();
      final nomorHp = _nomorHpController.text.trim();
      final nama = _namaController.text.trim(); // Ambil nama dari controller

      if (pasien == null) {
        // Create Pasien
        context.read<PasienBloc>().add(
              CreatePasienEvent(
                profileId: profileId,
                nik: nik.isNotEmpty ? nik : null,
                jenisKelamin: _jenisKelamin,
                tanggalLahir: tanggalLahir,
                alamat: alamat.isNotEmpty ? alamat : null,
                nomorHp: nomorHp.isNotEmpty ? nomorHp : null,
              ),
            );
      } else {
        // Update Pasien
        context.read<PasienBloc>().add(
              UpdatePasienEvent(
                pasienId: pasien!.pasienId,
                nik: nik.isNotEmpty ? nik : null,
                jenisKelamin: _jenisKelamin,
                tanggalLahir: tanggalLahir,
                alamat: alamat.isNotEmpty ? alamat : null,
                nomorHp: nomorHp.isNotEmpty ? nomorHp : null,
                profileName: nama, // Kirim nama
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: BlocConsumer<PasienBloc, PasienState>(
        listener: (context, state) {
          if (state is PasienFailure) {
            showSnackBar(context, state.error);
          } else if (state is PasienLoaded) {
            pasien = state.pasien;
            if (pasien != null) {
              _nikController.text = pasien!.nik ?? '';
              _tanggalLahirController.text = pasien!.tanggalLahir != null
                  ? DateFormat('dd/MM/yyyy').format(pasien!.tanggalLahir!)
                  : '';
              _alamatController.text = pasien!.alamat ?? '';
              _nomorHpController.text = pasien!.nomorHp ?? '';
              _jenisKelamin = pasien!.jenisKelamin;
              _namaController.text =
                  pasien!.profileName ?? ''; // Set nama dari data pasien
            }
          } else if (state is PasienCreated) {
            // Navigasi ke halaman profil
            Navigator.pushReplacement(context, PasienPage.route());
          }
        },
        builder: (context, state) {
          if (state is PasienLoading) {
            return const Loader();
          }

          return BlocBuilder<AppUserCubit, AppUserState>(
            builder: (context, appState) {
              String userName = "";
              if (appState is AppUserLoggedIn) {
                userName = appState.user.name ?? "";
                _namaController.text = userName; // Set nama dari AppUserCubit
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // **Nama**
                      Text("Nama",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      PasienField(
                        controller: _namaController,
                        hintText: 'Masukkan Nama',
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 16),

                      // **NIK**
                      Text("Nomor Induk Kependudukan (NIK)",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      PasienField(
                        controller: _nikController,
                        hintText: 'Masukkan NIK (opsional)',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      // **Jenis Kelamin**
                      Text("Jenis Kelamin",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        value: _jenisKelamin,
                        items: const [
                          DropdownMenuItem(
                            value: 'L',
                            child: Text('Laki-laki'),
                          ),
                          DropdownMenuItem(
                            value: 'P',
                            child: Text('Perempuan'),
                          ),
                        ],
                        hint: const Text('Pilih jenis kelamin'),
                        onChanged: (value) {
                          setState(() {
                            _jenisKelamin = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Jenis kelamin harus dipilih';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // **Tanggal Lahir**
                      Text("Tanggal Lahir",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      PasienField(
                        controller: _tanggalLahirController,
                        hintText: 'Pilih tanggal lahir (opsional)',
                        keyboardType: TextInputType.none,
                        readOnly: true,
                        onTap: () => _pickTanggalLahir(context),
                        suffixIcon: Icons.calendar_today,
                      ),
                      const SizedBox(height: 16),

                      // **Alamat**
                      Text("Alamat",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      PasienField(
                        controller: _alamatController,
                        hintText: 'Masukkan alamat (opsional)',
                        keyboardType: TextInputType.streetAddress,
                      ),
                      const SizedBox(height: 16),

                      // **Nomor HP**
                      Text("Nomor HP",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      PasienField(
                        controller: _nomorHpController,
                        hintText: 'Masukkan nomor HP (opsional)',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 24),

                      // **Tombol Simpan**
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final appUser = context.read<AppUserCubit>().state;
                            if (appUser is AppUserLoggedIn) {
                              _submitForm(appUser.user.id);
                            }
                          },
                          child: const Text('Simpan Profil'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/core/utils/custom_date_picker.dart';
import 'package:posbinduptm/core/utils/show_snackbar.dart';
import 'package:posbinduptm/features/pasien/domain/entities/pasien_entity.dart';
import 'package:posbinduptm/features/pasien/presentation/bloc/pasien_bloc.dart';
import 'package:posbinduptm/features/pasien/presentation/pages/detail_pasien_page.dart';

import '../widgets/pasien_field.dart';

class UploadPasienPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const UploadPasienPage(),
      );

  const UploadPasienPage({super.key});

  @override
  State<UploadPasienPage> createState() => _UploadPasienPageState();
}

class _UploadPasienPageState extends State<UploadPasienPage> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  final _alamatController = TextEditingController();
  final _nomorHpController = TextEditingController();

  String? _jenisKelamin;
  PasienEntity? pasien;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nikController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    _nomorHpController.dispose();

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
      // Tambahkan log
      final nik = _nikController.text.trim();
      final tanggalLahir = _tanggalLahirController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(_tanggalLahirController.text)
          : null;
      final alamat = _alamatController.text.trim();
      final nomorHp = _nomorHpController.text.trim();

      // Tambahkan log
      // Tambahkan log
      // ... tambahkan log untuk semua data

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
      // Tambahkan log
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
          } else if (state is PasienCreated) {
            // Navigasi ke halaman detail setelah berhasil membuat profil
            Navigator.pushReplacement(context, DetailPasienPage.route());
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
            }
          }
        },
        builder: (context, state) {
          if (state is PasienLoading) {
            return const Loader();
          }

          return BlocBuilder<AppUserCubit, AppUserState>(
              builder: (context, appState) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
          });
        },
      ),
    );
  }
}

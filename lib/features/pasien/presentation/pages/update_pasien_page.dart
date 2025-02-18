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

class UpdatePasienPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const UpdatePasienPage(),
      );

  const UpdatePasienPage({super.key, this.pasien});
  final PasienEntity? pasien;

  @override
  State<UpdatePasienPage> createState() => _UpdatePasienPageState();
}

class _UpdatePasienPageState extends State<UpdatePasienPage> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  final _alamatController = TextEditingController();
  final _nomorHpController = TextEditingController();
  final _namaController = TextEditingController();

  String? _jenisKelamin;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data pasien
    if (widget.pasien != null) {
      _nikController.text = widget.pasien!.nik ?? '';
      _tanggalLahirController.text = widget.pasien!.tanggalLahir != null
          ? DateFormat('dd/MM/yyyy').format(widget.pasien!.tanggalLahir!)
          : '';
      _alamatController.text = widget.pasien!.alamat ?? '';
      _nomorHpController.text = widget.pasien!.nomorHp ?? '';
      _namaController.text = widget.pasien!.profileName ?? '';
      _jenisKelamin = widget.pasien!.jenisKelamin;
    }
  }

  @override
  void dispose() {
    _nikController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    _nomorHpController.dispose();
    _namaController.dispose();
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final nik = _nikController.text.trim();
      final tanggalLahir = _tanggalLahirController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(_tanggalLahirController.text)
          : null;
      final alamat = _alamatController.text.trim();
      final nomorHp = _nomorHpController.text.trim();
      final nama = _namaController.text.trim(); // Ambil nama dari controller

      if (widget.pasien != null) {
        // Update Pasien
        debugPrint(
            'Memanggil UpdatePasienEvent dengan pasienId: ${widget.pasien!.pasienId}');
        context.read<PasienBloc>().add(
              UpdatePasienEvent(
                pasienId: widget.pasien!.pasienId,
                nik: nik.isNotEmpty ? nik : null,
                jenisKelamin: _jenisKelamin,
                tanggalLahir: tanggalLahir,
                alamat: alamat.isNotEmpty ? alamat : null,
                nomorHp: nomorHp.isNotEmpty ? nomorHp : null,
                profileName: nama, // Kirim nama
              ),
            );
      } else {
        debugPrint('Data pasien null, tidak dapat melakukan update');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profil Saya',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _submitForm();
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: BlocConsumer<PasienBloc, PasienState>(
        listener: (context, state) {
          if (state is PasienFailure) {
            showSnackBar(context, state.error);
            debugPrint('PasienFailure: ${state.error}');
          } else if (state is PasienLoaded) {
            // Kembali ke halaman detail setelah berhasil memperbarui profil
            Navigator.pop(context);
            showSnackBar(context, "Berhasil Edit Profil");
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
                _namaController.text = userName;
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

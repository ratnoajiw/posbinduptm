import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/core/utils/custom_date_picker.dart';
import 'package:posbinduptm/core/utils/show_snackbar.dart';
import 'package:posbinduptm/core/utils/custom_time_picker.dart';
import 'package:posbinduptm/features/antropometri/presentation/bloc/antropometri_bloc.dart';
import 'package:posbinduptm/features/antropometri/presentation/pages/antropometri_page.dart';
import 'package:posbinduptm/features/antropometri/presentation/widgets/antropometri_field.dart';

class AddAntropometriPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddAntropometriPage(),
      );

  const AddAntropometriPage({super.key});

  @override
  State<AddAntropometriPage> createState() => _AddAntropometriPageState();
}

class _AddAntropometriPageState extends State<AddAntropometriPage> {
  final tinggiBadanController = TextEditingController();
  final beratBadanController = TextEditingController();
  final lingkarPerutController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController waktuController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Future<void> _pickTanggal(BuildContext context) async {
    final String? selectedDate = await CustomDatePicker.pickDate(context);
    if (selectedDate != null) {
      setState(() {
        tanggalController.text = selectedDate;
      });
    }
  }

  Future<void> _pickWaktu(BuildContext context) async {
    final String? selectedTime = await CustomTimePicker.pickTime(context);
    if (selectedTime != null) {
      setState(() {
        waktuController.text = selectedTime;
      });
    }
  }

  void uploadAntropometri() {
    if (formKey.currentState!.validate()) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

      if (tanggalController.text.isEmpty || waktuController.text.isEmpty) {
        showSnackBar(context, 'Tanggal dan waktu harus diisi');
        return;
      }

      try {
        // Format dan parsing tanggal + waktu
        final DateTime pemeriksaanAt = DateFormat("dd/MM/yyyy HH:mm")
            .parse("${tanggalController.text} ${waktuController.text}");

        context.read<AntropometriBloc>().add(
              AntropometriUpload(
                posterId: posterId,
                updateAt: DateTime.now().toIso8601String(),
                tinggiBadan: double.parse(tinggiBadanController.text.trim()),
                beratBadan: double.parse(beratBadanController.text.trim()),
                lingkarPerut: double.parse(lingkarPerutController.text.trim()),
                pemeriksaanAt: pemeriksaanAt,
              ),
            );
      } catch (e) {
        showSnackBar(context, "Format tanggal atau waktu salah.");
      }
    }
  }

  @override
  void dispose() {
    tinggiBadanController.dispose();
    beratBadanController.dispose();
    lingkarPerutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Antropometri',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: uploadAntropometri,
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<AntropometriBloc, AntropometriState>(
        listener: (context, state) {
          if (state is AntropometriFailure) {
            showSnackBar(context, state.error);
          } else if (state is AntropometriUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              AntropometriPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is AntropometriLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tanggal Periksa",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    AntropometriField(
                      controller: tanggalController,

                      hintText: 'Pilih tanggal',
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      onTap: () => _pickTanggal(context),
                      suffixIcon: Icons.calendar_today, // Ikon kalender
                    ),
                    const SizedBox(height: 10),
                    Text("Waktu Periksa",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    AntropometriField(
                      controller: waktuController,

                      hintText: 'Pilih waktu',
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      onTap: () => _pickWaktu(context),
                      suffixIcon: Icons.access_time, // Ikon jam
                    ),
                    const SizedBox(height: 10),
                    Text("Tinggi Badan",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    AntropometriField(
                      controller: tinggiBadanController,
                      hintText: 'Contoh: 150',
                      keyboardType: TextInputType.number,
                      suffixText: 'cm',
                    ),
                    const SizedBox(height: 10),
                    Text("Berat Badan",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    AntropometriField(
                      controller: beratBadanController,
                      hintText: 'Contoh: 50',
                      keyboardType: TextInputType.number,
                      suffixText: 'kg',
                    ),
                    const SizedBox(height: 10),
                    Text("Lingkar Perut",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    AntropometriField(
                      controller: lingkarPerutController,
                      hintText: 'Contoh: 40',
                      suffixText: 'cm',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

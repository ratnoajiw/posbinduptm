import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/core/utils/custom_date_picker.dart';
import 'package:posbinduptm/core/utils/custom_time_picker.dart';
import 'package:posbinduptm/core/utils/show_snackbar.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/presentation/bloc/tekanan_darah_bloc.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/presentation/pages/tekanan_darah_page.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/presentation/widgets/tekanan_darah_field.dart';

class AddTekananDarahPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddTekananDarahPage(),
      );

  const AddTekananDarahPage({super.key});

  @override
  State<AddTekananDarahPage> createState() => _AddTekananDarahPageState();
}

class _AddTekananDarahPageState extends State<AddTekananDarahPage> {
  final sistolikController = TextEditingController();
  final diastolikController = TextEditingController();
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

  void uploadTekananDarah() {
    if (formKey.currentState!.validate()) {
      final profileId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

      if (tanggalController.text.isEmpty || waktuController.text.isEmpty) {
        showSnackBar(context, 'Tanggal dan waktu harus diisi');
        return;
      }

      try {
        final DateTime pemeriksaanAt = DateFormat("dd/MM/yyyy HH:mm")
            .parse("${tanggalController.text} ${waktuController.text}");

        context.read<TekananDarahBloc>().add(
              TekananDarahUpload(
                profileId: profileId,
                sistolik: double.parse(sistolikController.text.trim()),
                diastolik: double.parse(diastolikController.text.trim()),
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
    sistolikController.dispose();
    diastolikController.dispose();
    tanggalController.dispose();
    waktuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pemeriksaan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: uploadTekananDarah,
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<TekananDarahBloc, TekananDarahState>(
        listener: (context, state) {
          if (state is TekananDarahFailure) {
            showSnackBar(context, state.error);
          } else if (state is TekananDarahUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              TekananDarahPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is TekananDarahLoading) {
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
                    TekananDarahField(
                      controller: tanggalController,
                      hintText: 'Pilih tanggal',
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      onTap: () => _pickTanggal(context),
                      suffixIcon: Icons.calendar_today,
                    ),
                    const SizedBox(height: 10),
                    Text("Waktu Periksa",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    TekananDarahField(
                      controller: waktuController,
                      hintText: 'Pilih waktu',
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      onTap: () => _pickWaktu(context),
                      suffixIcon: Icons.access_time,
                    ),
                    const SizedBox(height: 10),
                    Text("Tekanan Darah Sistolik",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    TekananDarahField(
                      controller: sistolikController,
                      hintText: 'Contoh: 120',
                      keyboardType: TextInputType.number,
                      suffixText: 'mmHg',
                    ),
                    const SizedBox(height: 10),
                    Text("Tekanan Darah Diastolik",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    TekananDarahField(
                      controller: diastolikController,
                      hintText: 'Contoh: 80',
                      keyboardType: TextInputType.number,
                      suffixText: 'mmHg',
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

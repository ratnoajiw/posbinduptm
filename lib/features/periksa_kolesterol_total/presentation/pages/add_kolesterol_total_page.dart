import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/core/utils/custom_date_picker.dart';
import 'package:posbinduptm/core/utils/custom_time_picker.dart';
import 'package:posbinduptm/core/utils/show_snackbar.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/presentation/bloc/kolesterol_total_bloc.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/presentation/pages/kolesterol_total_page.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/presentation/widgets/kolesterol_total_field.dart';

class AddKolesterolTotalPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddKolesterolTotalPage(),
      );

  const AddKolesterolTotalPage({super.key});

  @override
  State<AddKolesterolTotalPage> createState() => _AddKolesterolTotalPageState();
}

class _AddKolesterolTotalPageState extends State<AddKolesterolTotalPage> {
  final kolesterolTotalController = TextEditingController();
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

  void uploadKolesterolTotal() {
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

        context.read<KolesterolTotalBloc>().add(
              KolesterolTotalUpload(
                profileId: profileId,
                kolesterolTotal:
                    double.parse(kolesterolTotalController.text.trim()),
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
    kolesterolTotalController.dispose();
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
            onPressed: uploadKolesterolTotal,
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<KolesterolTotalBloc, KolesterolTotalState>(
        listener: (context, state) {
          if (state is KolesterolTotalFailure) {
            showSnackBar(context, state.error);
          } else if (state is KolesterolTotalUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              KolesterolTotalPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is KolesterolTotalLoading) {
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
                    KolesterolTotalField(
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
                    KolesterolTotalField(
                      controller: waktuController,
                      hintText: 'Pilih waktu',
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      onTap: () => _pickWaktu(context),
                      suffixIcon: Icons.access_time,
                    ),
                    const SizedBox(height: 10),
                    Text("Kolesterol Total",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    KolesterolTotalField(
                      controller: kolesterolTotalController,
                      hintText: 'Contoh: 200',
                      keyboardType: TextInputType.number,
                      suffixText: 'mg/dL',
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:posbinduptm/core/utils/custom_date_picker.dart';
import 'package:posbinduptm/core/utils/custom_time_picker.dart';
import 'package:posbinduptm/features/periksa_antropometri/presentation/bloc/antropometri_bloc.dart';
import 'package:posbinduptm/features/periksa_antropometri/presentation/widgets/antropometri_field.dart';

class UpdateAntropometriPage extends StatefulWidget {
  final String id;
  final double tinggiBadan;
  final double beratBadan;
  final double lingkarPerut;
  final DateTime pemeriksaanAt;

  const UpdateAntropometriPage({
    super.key,
    required this.id,
    required this.tinggiBadan,
    required this.beratBadan,
    required this.lingkarPerut,
    required this.pemeriksaanAt,
  });

  @override
  State<UpdateAntropometriPage> createState() => _EditAntropometriPageState();
}

class _EditAntropometriPageState extends State<UpdateAntropometriPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController tinggiBadanController;
  late TextEditingController beratBadanController;
  late TextEditingController lingkarPerutController;
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController waktuController = TextEditingController();

  bool isLoading = false; // Untuk menampilkan indikator loading

  @override
  void initState() {
    super.initState();
    tinggiBadanController =
        TextEditingController(text: widget.tinggiBadan.toString());
    beratBadanController =
        TextEditingController(text: widget.beratBadan.toString());
    lingkarPerutController =
        TextEditingController(text: widget.lingkarPerut.toString());
    tanggalController.text =
        DateFormat('dd/MM/yyyy').format(widget.pemeriksaanAt);
    waktuController.text = DateFormat('HH:mm').format(widget.pemeriksaanAt);
  }

  @override
  void dispose() {
    tinggiBadanController.dispose();
    beratBadanController.dispose();
    lingkarPerutController.dispose();
    tanggalController.dispose();
    waktuController.dispose();
    super.dispose();
  }

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

  void _updateAntropometri() {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      DateTime pemeriksaanAt = DateFormat('dd/MM/yyyy HH:mm')
          .parse('${tanggalController.text} ${waktuController.text}');

      context.read<AntropometriBloc>().add(AntropometriUpdate(
            id: widget.id,
            tinggiBadan: double.parse(tinggiBadanController.text),
            beratBadan: double.parse(beratBadanController.text),
            lingkarPerut: double.parse(lingkarPerutController.text),
            pemeriksaanAt: pemeriksaanAt,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AntropometriBloc, AntropometriState>(
      listener: (context, state) {
        if (state is AntropometriUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data berhasil diperbarui")),
          );
          Navigator.pop(context, true);
        } else if (state is AntropometriFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
        setState(() =>
            isLoading = false); // Nonaktifkan loading setelah proses selesai
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Data Antropometri",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: isLoading
                  ? null
                  : _updateAntropometri, // Disable saat loading
              icon: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.done_rounded),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
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
                    hintText: 'Contoh: 150 (cm)',
                    keyboardType: TextInputType.number,
                    suffixText: 'cm',
                  ),
                  const SizedBox(height: 10),
                  Text("Berat Badan",
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  AntropometriField(
                    controller: beratBadanController,
                    hintText: 'Contoh: 50 (kg)',
                    keyboardType: TextInputType.number,
                    suffixText: 'kg',
                  ),
                  const SizedBox(height: 10),
                  Text("Lingkar Perut",
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  AntropometriField(
                    controller: lingkarPerutController,
                    hintText: 'Contoh: 40 (cm)',
                    suffixText: 'cm',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

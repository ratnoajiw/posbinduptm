import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:posbinduptm/core/utils/custom_date_picker.dart';
import 'package:posbinduptm/core/utils/custom_time_picker.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/presentation/bloc/tekanan_darah_bloc.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/presentation/widgets/tekanan_darah_field.dart';

class UpdateTekananDarahPage extends StatefulWidget {
  final String tekananDarahId;
  final double sistolik;
  final double diastolik;
  final DateTime pemeriksaanAt;

  const UpdateTekananDarahPage({
    super.key,
    required this.tekananDarahId,
    required this.sistolik,
    required this.diastolik,
    required this.pemeriksaanAt,
  });

  @override
  State<UpdateTekananDarahPage> createState() => _UpdateTekananDarahPageState();
}

class _UpdateTekananDarahPageState extends State<UpdateTekananDarahPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController sistolikController;
  late TextEditingController diastolikController;
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController waktuController = TextEditingController();

  @override
  void initState() {
    super.initState();
    sistolikController =
        TextEditingController(text: widget.sistolik.toString());
    diastolikController =
        TextEditingController(text: widget.diastolik.toString());
    tanggalController.text =
        DateFormat('dd/MM/yyyy').format(widget.pemeriksaanAt);
    waktuController.text = DateFormat('HH:mm').format(widget.pemeriksaanAt);
  }

  @override
  void dispose() {
    sistolikController.dispose();
    diastolikController.dispose();
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

  void _updateTekananDarah() {
    if (_formKey.currentState!.validate()) {
      DateTime pemeriksaanAt = DateFormat('dd/MM/yyyy HH:mm')
          .parse('${tanggalController.text} ${waktuController.text}');

      context.read<TekananDarahBloc>().add(TekananDarahUpdate(
            tekananDarahId: widget.tekananDarahId,
            sistolik: double.parse(sistolikController.text),
            diastolik: double.parse(diastolikController.text),
            pemeriksaanAt: pemeriksaanAt,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TekananDarahBloc, TekananDarahState>(
      listener: (context, state) {
        // **Tambahkan listener untuk state TekananDarahUpdateSuccess dan TekananDarahFailure**
        if (state is TekananDarahUpdateSuccess) {
          Navigator.pop(context); // <-- Navigasi kembali
        } else if (state is TekananDarahFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Pemeriksaan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: _updateTekananDarah,
              icon: const Icon(Icons.done_rounded),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
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
      ),
    );
  }
}

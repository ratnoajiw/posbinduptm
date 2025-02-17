import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:posbinduptm/core/utils/custom_date_picker.dart';
import 'package:posbinduptm/core/utils/custom_time_picker.dart';
import 'package:posbinduptm/features/periksa_gula_darah/presentation/bloc/gula_darah_bloc.dart';
import 'package:posbinduptm/features/periksa_gula_darah/presentation/widgets/gula_darah_field.dart';

class UpdateGulaDarahPage extends StatefulWidget {
  final String gulaDarahId;
  final double gulaDarahSewaktuId;
  final DateTime pemeriksaanAt;

  const UpdateGulaDarahPage({
    super.key,
    required this.gulaDarahId,
    required this.gulaDarahSewaktuId,
    required this.pemeriksaanAt,
  });

  @override
  State<UpdateGulaDarahPage> createState() => _UpdateGulaDarahPageState();
}

class _UpdateGulaDarahPageState extends State<UpdateGulaDarahPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController gulaDarahController;
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController waktuController = TextEditingController();

  @override
  void initState() {
    super.initState();
    gulaDarahController =
        TextEditingController(text: widget.gulaDarahSewaktuId.toString());
    tanggalController.text =
        DateFormat('dd/MM/yyyy').format(widget.pemeriksaanAt);
    waktuController.text = DateFormat('HH:mm').format(widget.pemeriksaanAt);
  }

  @override
  void dispose() {
    gulaDarahController.dispose();
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

  void _updateGulaDarah() {
    if (_formKey.currentState!.validate()) {
      DateTime pemeriksaanAt = DateFormat('dd/MM/yyyy HH:mm')
          .parse('${tanggalController.text} ${waktuController.text}');

      context.read<GulaDarahBloc>().add(GulaDarahUpdate(
            gulaDarahId: widget.gulaDarahId,
            gulaDarahSewaktu: double.parse(gulaDarahController.text),
            pemeriksaanAt: pemeriksaanAt,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GulaDarahBloc, GulaDarahState>(
      listener: (context, state) {
        if (state is GulaDarahUpdateSuccess) {
          Navigator.pop(context); // <-- Navigasi kembali
        } else if (state is GulaDarahFailure) {
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
              onPressed: _updateGulaDarah,
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
                GulaDarahField(
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
                GulaDarahField(
                  controller: waktuController,
                  hintText: 'Pilih waktu',
                  keyboardType: TextInputType.none,
                  readOnly: true,
                  onTap: () => _pickWaktu(context),
                  suffixIcon: Icons.access_time,
                ),
                const SizedBox(height: 10),
                Text("Gula Darah Sewaktu",
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                GulaDarahField(
                  controller: gulaDarahController,
                  hintText: 'Contoh: 110 (mg/dL)',
                  keyboardType: TextInputType.number,
                  suffixText: 'mg/dL',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

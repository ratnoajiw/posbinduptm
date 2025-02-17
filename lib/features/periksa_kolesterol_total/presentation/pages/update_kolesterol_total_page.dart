import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:posbinduptm/core/utils/custom_date_picker.dart';
import 'package:posbinduptm/core/utils/custom_time_picker.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/presentation/bloc/kolesterol_total_bloc.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/presentation/widgets/kolesterol_total_field.dart';

class UpdateKolesterolTotalPage extends StatefulWidget {
  final String kolesterolTotalId;
  final double kolesterolTotal;
  final DateTime pemeriksaanAt;

  const UpdateKolesterolTotalPage({
    super.key,
    required this.kolesterolTotalId,
    required this.kolesterolTotal,
    required this.pemeriksaanAt,
  });

  @override
  State<UpdateKolesterolTotalPage> createState() =>
      _UpdateKolesterolTotalPageState();
}

class _UpdateKolesterolTotalPageState extends State<UpdateKolesterolTotalPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController kolesterolTotalController;
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController waktuController = TextEditingController();

  @override
  void initState() {
    super.initState();
    kolesterolTotalController =
        TextEditingController(text: widget.kolesterolTotal.toString());
    tanggalController.text =
        DateFormat('dd/MM/yyyy').format(widget.pemeriksaanAt);
    waktuController.text = DateFormat('HH:mm').format(widget.pemeriksaanAt);
  }

  @override
  void dispose() {
    kolesterolTotalController.dispose();
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

  void _updateKolesterolTotal() {
    if (_formKey.currentState!.validate()) {
      DateTime pemeriksaanAt = DateFormat('dd/MM/yyyy HH:mm')
          .parse('${tanggalController.text} ${waktuController.text}');

      context.read<KolesterolTotalBloc>().add(KolesterolTotalUpdate(
            kolesterolTotalId: widget.kolesterolTotalId,
            kolesterolTotal: double.parse(kolesterolTotalController.text),
            pemeriksaanAt: pemeriksaanAt,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<KolesterolTotalBloc, KolesterolTotalState>(
      listener: (context, state) {
        if (state is KolesterolTotalUpdateSuccess) {
          Navigator.pop(context);
        } else if (state is KolesterolTotalFailure) {
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
              onPressed: _updateKolesterolTotal,
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
      ),
    );
  }
}

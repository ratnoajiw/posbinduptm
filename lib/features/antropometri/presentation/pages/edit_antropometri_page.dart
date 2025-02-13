import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/features/antropometri/presentation/bloc/antropometri_bloc.dart';
import 'package:posbinduptm/features/antropometri/presentation/widgets/antropometri_field.dart';

class EditAntropometriPage extends StatefulWidget {
  final String id;
  final double tinggiBadan;
  final double beratBadan;
  final double lingkarPerut;

  const EditAntropometriPage({
    super.key,
    required this.id,
    required this.tinggiBadan,
    required this.beratBadan,
    required this.lingkarPerut,
  });

  @override
  State<EditAntropometriPage> createState() => _EditAntropometriPageState();
}

class _EditAntropometriPageState extends State<EditAntropometriPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController tinggiBadanController;
  late TextEditingController beratBadanController;
  late TextEditingController lingkarPerutController;
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
  }

  @override
  void dispose() {
    tinggiBadanController.dispose();
    beratBadanController.dispose();
    lingkarPerutController.dispose();
    super.dispose();
  }

  void _updateAntropometri() {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true); // Aktifkan loading

      context.read<AntropometriBloc>().add(AntropometriUpdate(
            id: widget.id,
            tinggiBadan: double.parse(tinggiBadanController.text),
            beratBadan: double.parse(beratBadanController.text),
            lingkarPerut: double.parse(lingkarPerutController.text),
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
          title: const Text("Edit Data Antropometri"),
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
                  const Text(
                    "Masukkan Data Antropometri",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 15),
                  AntropometriField(
                    controller: tinggiBadanController,
                    labelTextField: 'Tinggi Badan',
                    hintText: 'Tinggi Badan (cm)',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  AntropometriField(
                    controller: beratBadanController,
                    labelTextField: 'Berat Badan',
                    hintText: 'Berat Badan (kg)',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  AntropometriField(
                    controller: lingkarPerutController,
                    hintText: 'Lingkar Perut (cm)',
                    labelTextField: 'Lingkar Perut',
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

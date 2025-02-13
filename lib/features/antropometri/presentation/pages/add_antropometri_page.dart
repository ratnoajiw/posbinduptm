import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/core/utils/show_snackbar.dart';
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
  final formKey = GlobalKey<FormState>();

  void uploadAntropometri() {
    if (formKey.currentState!.validate()) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

      context.read<AntropometriBloc>().add(
            AntropometriUpload(
              posterId: posterId,
              tanggal: DateTime.now()
                  .toIso8601String(), // Add the required 'tanggal' argument
              tinggiBadan: double.parse(tinggiBadanController.text.trim()),
              beratBadan: double.parse(beratBadanController.text.trim()),
              lingkarPerut: double.parse(lingkarPerutController.text.trim()),
            ),
          );
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
        title: const Text('Tambah Antropometri'),
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
                      labelTextField: 'Lingkar Perut',
                      hintText: 'Lingkar Perut (cm)',
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

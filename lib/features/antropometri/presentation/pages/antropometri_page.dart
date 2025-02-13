import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/app_drawer.dart';
import 'package:posbinduptm/core/common/widgets/custom_delete_dialog.dart';
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/core/utils/show_snackbar.dart';
import 'package:posbinduptm/features/antropometri/domain/entities/antropometri_entity.dart';
import 'package:posbinduptm/features/antropometri/presentation/bloc/antropometri_bloc.dart';
import 'package:posbinduptm/features/antropometri/presentation/pages/add_antropometri_page.dart';
import 'package:posbinduptm/features/antropometri/presentation/widgets/antropometri_card.dart';

class AntropometriPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AntropometriPage(),
      );

  const AntropometriPage({super.key});

  @override
  State<AntropometriPage> createState() => _AntropometriPageState();
}

class _AntropometriPageState extends State<AntropometriPage> {
  @override
  void initState() {
    super.initState();
    final state = context.read<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      final posterId = state.user.id;
      context
          .read<AntropometriBloc>()
          .add(AntropometriGetAllAntropometris(posterId: posterId));
    }
  }

  void _showDeleteDialog(BuildContext context, String antropometriId) {
    showDialog(
      context: context,
      builder: (ctx) => CustomDeleteDialog(
        title: "Hapus Data",
        content: "Apakah Anda yakin ingin menghapus data ini?",
        onConfirm: () {
          context
              .read<AntropometriBloc>()
              .add(AntropometriDelete(antropometriId: antropometriId));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AntropometriBloc, AntropometriState>(
      listener: (context, state) {
        if (state is AntropometriFailure) {
          showSnackBar(context, state.error);
        } else if (state is AntropometriDeleteSuccess) {
          showSnackBar(context, "Data berhasil dihapus");
          final userState = context.read<AppUserCubit>().state;
          if (userState is AppUserLoggedIn) {
            context.read<AntropometriBloc>().add(
                  AntropometriGetAllAntropometris(posterId: userState.user.id),
                );
          }
        } else if (state is AntropometriUpdateSuccess) {
          final userState = context.read<AppUserCubit>().state;
          if (userState is AppUserLoggedIn) {
            context.read<AntropometriBloc>().add(
                  AntropometriGetAllAntropometris(posterId: userState.user.id),
                );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Data Antropometri'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, AddAntropometriPage.route());
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: BlocBuilder<AntropometriBloc, AntropometriState>(
          builder: (context, state) {
            if (state is AntropometriLoading) {
              return const Loader();
            } else if (state is AntropometrisDisplaySuccess ||
                state is AntropometriUpdateSuccess) {
              // 🔥 Tambahkan kondisi ini
              final List<AntropometriEntity> antropometriList =
                  state is AntropometrisDisplaySuccess
                      ? state.antropometris
                      : []; // Gunakan list kosong jika state belum diperbarui

              if (antropometriList.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada data antropometri',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }

              return ListView.builder(
                itemCount: antropometriList.length,
                itemBuilder: (context, index) {
                  final antropometri = antropometriList[index];

                  return AntropometriCard(
                    antropometri: antropometri,
                    onDelete: () => _showDeleteDialog(context, antropometri.id),
                    color: index % 3 == 0
                        ? AppPallete.gradientGreen1
                        : index % 3 == 1
                            ? AppPallete.gradientGreen2
                            : AppPallete.gradientGreen3,
                  );
                },
              );
            } else if (state is AntropometriFailure) {
              return Center(child: Text("Terjadi kesalahan: ${state.error}"));
            }
            return const Loader();
          },
        ),
      ),
    );
  }
}

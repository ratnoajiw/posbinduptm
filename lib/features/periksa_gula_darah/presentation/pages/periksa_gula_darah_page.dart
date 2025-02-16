import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/app_drawer.dart';
import 'package:posbinduptm/core/common/widgets/custom_delete_dialog.dart';
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/core/utils/show_snackbar.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/periksa_gula_darah_entity.dart';
import 'package:posbinduptm/features/periksa_gula_darah/presentation/bloc/periksa_gula_darah_bloc.dart';
import 'package:posbinduptm/features/periksa_gula_darah/presentation/pages/add_gula_darah_page.dart';
import 'package:posbinduptm/features/periksa_gula_darah/presentation/pages/detail_periksa_gula_darah.dart';
import 'package:posbinduptm/features/periksa_gula_darah/presentation/widgets/gula_darah_card.dart';

class PeriksaGulaDarahPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const PeriksaGulaDarahPage(),
      );

  const PeriksaGulaDarahPage({super.key});

  @override
  State<PeriksaGulaDarahPage> createState() => _PeriksaGulaDarahPageState();
}

class _PeriksaGulaDarahPageState extends State<PeriksaGulaDarahPage> {
  @override
  void initState() {
    super.initState();
    final state = context.read<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      final profileId = state.user.id;
      context
          .read<PeriksaGulaDarahBloc>()
          .add(PeriksaGulaDarahList(profileId: profileId));
    }
  }

  void _showDeleteDialog(BuildContext context, String periksaId) {
    showDialog(
      context: context,
      builder: (ctx) => CustomDeleteDialog(
        title: "Hapus Data",
        content: "Apakah Anda yakin ingin menghapus data ini?",
        onConfirm: () {
          context
              .read<PeriksaGulaDarahBloc>()
              .add(PeriksaGulaDarahDelete(gulaDarahSewaktuId: periksaId));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PeriksaGulaDarahBloc, PeriksaGulaDarahState>(
      listener: (context, state) {
        if (state is PeriksaGulaDarahFailure) {
          showSnackBar(context, state.error);
        } else if (state is PeriksaGulaDarahDeleteSuccess) {
          showSnackBar(context, "Data berhasil dihapus");
          final userState = context.read<AppUserCubit>().state;
          if (userState is AppUserLoggedIn) {
            context.read<PeriksaGulaDarahBloc>().add(
                  PeriksaGulaDarahList(profileId: userState.user.id),
                );
          }
        } else if (state is PeriksaGulaDarahUpdateSuccess) {
          showSnackBar(context, "Data berhasil diupdate");
          final userState = context.read<AppUserCubit>().state;
          if (userState is AppUserLoggedIn) {
            context.read<PeriksaGulaDarahBloc>().add(
                  PeriksaGulaDarahList(profileId: userState.user.id),
                );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gula Darah',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, AddGulaDarahPage.route());
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: BlocBuilder<PeriksaGulaDarahBloc, PeriksaGulaDarahState>(
          builder: (context, state) {
            if (state is PeriksaGulaDarahLoading) {
              return const Loader();
            } else if (state is PeriksaGulaDarahDisplaySuccess) {
              final List<PeriksaGulaDarahEntity> gulaDarahList =
                  state.periksaGulaDarahList;

              if (gulaDarahList.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada data pemeriksaan gula darah',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }

              return ListView.builder(
                itemCount: gulaDarahList.length,
                itemBuilder: (context, index) {
                  final gulaDarah = gulaDarahList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailGulaDarahPage(gulaDarah: gulaDarah),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        GulaDarahCard(
                          gulaDarah: gulaDarah,
                          onDelete: () =>
                              _showDeleteDialog(context, gulaDarah.id),
                          color: index % 3 == 0
                              ? AppPallete.gradientGreen1
                              : AppPallete.gradientGreen2,
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is PeriksaGulaDarahFailure) {
              return Center(child: Text("Terjadi kesalahan: ${state.error}"));
            }
            return const Loader();
          },
        ),
      ),
    );
  }
}

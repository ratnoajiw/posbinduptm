import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/app_drawer.dart';
import 'package:posbinduptm/core/common/widgets/custom_delete_dialog.dart';
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/core/utils/show_snackbar.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/entities/tekanan_darah_entity.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/presentation/bloc/tekanan_darah_bloc.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/presentation/pages/add_tekanan_darah_page.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/presentation/pages/detail_tekanan_darah_page.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/presentation/widgets/tekanan_darah_card.dart';

class TekananDarahPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const TekananDarahPage(),
      );

  const TekananDarahPage({super.key});

  @override
  State<TekananDarahPage> createState() => _TekananDarahPageState();
}

class _TekananDarahPageState extends State<TekananDarahPage> {
  @override
  void initState() {
    super.initState();
    final state = context.read<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      final profileId = state.user.id;
      context
          .read<TekananDarahBloc>()
          .add(TekananDarahList(profileId: profileId));
    }
  }

  void _showDeleteDialog(BuildContext context, String tekananDarahId) {
    showDialog(
      context: context,
      builder: (ctx) => CustomDeleteDialog(
        title: "Hapus Data",
        content: "Apakah Anda yakin ingin menghapus data ini?",
        onConfirm: () {
          context
              .read<TekananDarahBloc>()
              .add(TekananDarahDelete(tekananDarahId: tekananDarahId));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TekananDarahBloc, TekananDarahState>(
      listener: (context, state) {
        if (state is TekananDarahFailure) {
          showSnackBar(context, state.error);
        } else if (state is TekananDarahDeleteSuccess) {
          showSnackBar(context, "Data berhasil dihapus");
          final userState = context.read<AppUserCubit>().state;
          if (userState is AppUserLoggedIn) {
            context.read<TekananDarahBloc>().add(
                  TekananDarahList(profileId: userState.user.id),
                );
          }
        } else if (state is TekananDarahUpdateSuccess) {
          showSnackBar(context, "Data berhasil diupdate");
          final userState = context.read<AppUserCubit>().state;
          if (userState is AppUserLoggedIn) {
            context.read<TekananDarahBloc>().add(
                  TekananDarahList(profileId: userState.user.id),
                );
          }
        } else if (state is TekananDarahUploadSuccess) {
          showSnackBar(context, "Data berhasil diupload");
          final userState = context.read<AppUserCubit>().state;
          if (userState is AppUserLoggedIn) {
            context.read<TekananDarahBloc>().add(
                  TekananDarahList(profileId: userState.user.id),
                );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tekanan Darah',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, AddTekananDarahPage.route());
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: BlocBuilder<TekananDarahBloc, TekananDarahState>(
          builder: (context, state) {
            if (state is TekananDarahLoading) {
              return const Loader();
            } else if (state is TekananDarahDisplaySuccess) {
              final List<TekananDarahEntity> tekananDarahList =
                  state.tekananDarahList;

              if (tekananDarahList.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada data pemeriksaan tekanan darah',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }

              return ListView.builder(
                itemCount: tekananDarahList.length,
                itemBuilder: (context, index) {
                  final tekananDarah = tekananDarahList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailTekananDarahPage(
                              tekananDarah: tekananDarah),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        TekananDarahCard(
                          tekananDarah: tekananDarah,
                          onDelete: () => _showDeleteDialog(
                              context, tekananDarah.tekananDarahId),
                          color: index % 3 == 0
                              ? AppPallete.gradientGreen1
                              : AppPallete.gradientGreen2,
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is TekananDarahFailure) {
              return Center(child: Text("Terjadi kesalahan: ${state.error}"));
            }
            return const Loader();
          },
        ),
      ),
    );
  }
}

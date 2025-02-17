import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/app_drawer.dart';
import 'package:posbinduptm/core/common/widgets/custom_delete_dialog.dart';
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/core/utils/show_snackbar.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/entities/kolesterol_total_entity.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/presentation/bloc/kolesterol_total_bloc.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/presentation/pages/add_kolesterol_total_page.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/presentation/pages/detail_kolesterol_total_page.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/presentation/widgets/kolesterol_total_card.dart';

class KolesterolTotalPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const KolesterolTotalPage(),
      );

  const KolesterolTotalPage({super.key});

  @override
  State<KolesterolTotalPage> createState() => _KolesterolTotalPageState();
}

class _KolesterolTotalPageState extends State<KolesterolTotalPage> {
  @override
  void initState() {
    super.initState();
    final state = context.read<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      final profileId = state.user.id;
      context
          .read<KolesterolTotalBloc>()
          .add(KolesterolTotalList(profileId: profileId));
    }
  }

  void _showDeleteDialog(BuildContext context, String kolesterolTotalId) {
    showDialog(
      context: context,
      builder: (ctx) => CustomDeleteDialog(
        title: "Hapus Data",
        content: "Apakah Anda yakin ingin menghapus data ini?",
        onConfirm: () {
          context
              .read<KolesterolTotalBloc>()
              .add(KolesterolTotalDelete(kolesterolTotalId: kolesterolTotalId));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<KolesterolTotalBloc, KolesterolTotalState>(
      listener: (context, state) {
        if (state is KolesterolTotalFailure) {
          showSnackBar(context, state.error);
        } else if (state is KolesterolTotalDeleteSuccess) {
          showSnackBar(context, "Data berhasil dihapus");
          final userState = context.read<AppUserCubit>().state;
          if (userState is AppUserLoggedIn) {
            context.read<KolesterolTotalBloc>().add(
                  KolesterolTotalList(profileId: userState.user.id),
                );
          }
        } else if (state is KolesterolTotalUpdateSuccess) {
          showSnackBar(context, "Data berhasil diupdate");
          final userState = context.read<AppUserCubit>().state;
          if (userState is AppUserLoggedIn) {
            context.read<KolesterolTotalBloc>().add(
                  KolesterolTotalList(profileId: userState.user.id),
                );
          }
        } else if (state is KolesterolTotalUploadSuccess) {
          showSnackBar(context, "Data berhasil diupload");
          final userState = context.read<AppUserCubit>().state;
          if (userState is AppUserLoggedIn) {
            context.read<KolesterolTotalBloc>().add(
                  KolesterolTotalList(profileId: userState.user.id),
                );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kolesterol Total',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, AddKolesterolTotalPage.route());
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: BlocBuilder<KolesterolTotalBloc, KolesterolTotalState>(
          builder: (context, state) {
            if (state is KolesterolTotalLoading) {
              return const Loader();
            } else if (state is KolesterolTotalDisplaySuccess) {
              final List<KolesterolTotalEntity> kolesterolTotalList =
                  state.kolesterolTotalList;

              if (kolesterolTotalList.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada data\npemeriksaan kolesterol total',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }

              return ListView.builder(
                itemCount: kolesterolTotalList.length,
                itemBuilder: (context, index) {
                  final kolesterolTotal = kolesterolTotalList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailKolesterolTotalPage(
                                  kolesterolTotal: kolesterolTotal)));
                    },
                    child: Column(
                      children: [
                        KolesterolTotalCard(
                          kolesterolTotal: kolesterolTotal,
                          onDelete: () => _showDeleteDialog(
                              context, kolesterolTotal.kolesterolTotalId),
                          color: index % 3 == 0
                              ? AppPallete.gradientGreen1
                              : AppPallete.gradientGreen2,
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is KolesterolTotalFailure) {
              return Center(child: Text("Terjadi kesalahan: ${state.error}"));
            }
            return const Loader();
          },
        ),
      ),
    );
  }
}

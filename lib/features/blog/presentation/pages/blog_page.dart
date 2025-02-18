import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/app_drawer.dart'; // Import Drawer Baru
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/core/utils/show_snackbar.dart';
import 'package:posbinduptm/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:posbinduptm/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:posbinduptm/features/blog/presentation/widgets/blog_card.dart';
import 'package:posbinduptm/features/pasien/presentation/bloc/pasien_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const BlogPage(),
      );
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  void refreshBlogs() {
    final state = context.read<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      final posterId = state.user.id;
      context.read<BlogBloc>().add(BlogGetAllBlogs(posterId: posterId));
    }
  }

  @override
  void initState() {
    super.initState();
    refreshBlogs();
    // Ambil data pasien setelah halaman diinisialisasi
    final appUser = context.read<AppUserCubit>().state;
    if (appUser is AppUserLoggedIn) {
      context
          .read<PasienBloc>()
          .add(GetPasienEvent(profileId: appUser.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Artikel Blog',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(context, AddNewBlogPage.route());
              if (!context.mounted) return;
              refreshBlogs();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          if (state is BlogsDisplaySuccess) {
            if (state.blogs.isEmpty) {
              return const Center(
                child: Text(
                  "Belum ada data blog artikel",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                refreshBlogs();
              },
              child: ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  final blog = state.blogs[index];
                  return BlogCard(
                    blog: blog,
                    color: index % 3 == 0
                        ? AppPallete.gradientGreen1
                        : AppPallete.gradientGreen2,
                    onUpdated: refreshBlogs, // Tambahkan callback update
                  );
                },
              ),
            );
          } else if (state is BlogFailure) {
            return Center(child: Text("Terjadi kesalahan: ${state.error}"));
          }
          return const Loader();
        },
      ),
    );
  }
}

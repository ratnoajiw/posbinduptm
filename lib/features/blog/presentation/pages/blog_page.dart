import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/app_drawer.dart'; // Import Drawer Baru
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/core/utils/show_snackbar.dart';
import 'package:posbinduptm/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:posbinduptm/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:posbinduptm/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:posbinduptm/features/blog/presentation/widgets/blog_card.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const BlogPage(),
      );
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    final state = context.read<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      final posterId = state.user.id;
      context.read<BlogBloc>().add(BlogGetAllBlogs(posterId: posterId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Blog Artikel'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, AddNewBlogPage.route());
              },
              icon: const Icon(Icons.add_circle),
            ),
          ],
        ),
        drawer: const AppDrawer(), // Menggunakan Drawer yang Dipisah
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
                // 🔥 Tampilkan pesan jika tidak ada data
                return const Center(
                  child: Text(
                    "Belum ada data blog artikel",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }

              return ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  final blog = state.blogs[index];
                  return BlogCard(
                    blog: blog,
                    color: index % 3 == 0
                        ? AppPallete.gradientGreen1
                        : index % 3 == 1
                            ? AppPallete.gradientGreen2
                            : AppPallete.gradientGreen3,
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

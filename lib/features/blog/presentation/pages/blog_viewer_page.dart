import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/custom_delete_dialog.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/core/utils/calculate_reading_time.dart';
import 'package:posbinduptm/core/utils/format_date.dart';
import 'package:posbinduptm/features/blog/domain/entities/blog_entity.dart';
import '../bloc/blog_bloc.dart';

class BlogViewerPage extends StatelessWidget {
  static route(BlogEntity blog) => MaterialPageRoute(
        builder: (context) => BlogViewerPage(blog: blog),
      );

  final BlogEntity blog;

  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogDeleteSuccess) {
          final userState = context.read<AppUserCubit>().state;
          if (userState is AppUserLoggedIn) {
            context.read<BlogBloc>().add(BlogGetAllBlogs(
                posterId: userState.user.id)); // Refresh daftar blog
          }
          Navigator.pop(context); // Kembali ke BlogPage
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppPallete.whiteColor,
          elevation: 0,
          title: const Text(
            "Detail Blog",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(context, blog.id),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // **Title**
              Text(
                blog.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // **Author & Date**
              Text(
                'by ${blog.posterName}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppPallete.greyColor,
                ),
              ),
              Text(
                '${formatDateBydMMMYYYY(blog.updatedAt)} • ${calculateReadingTime(blog.content)} min read',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),

              // **Image**
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  blog.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // **Content**
              Text(
                blog.content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.8,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String blogId) {
    showDialog(
      context: context,
      builder: (ctx) => CustomDeleteDialog(
        title: "Hapus Blog",
        content: "Apakah Anda yakin ingin menghapus blog ini?",
        onConfirm: () {
          context.read<BlogBloc>().add(BlogDelete(blogId: blogId));
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/core/common/widgets/custom_delete_dialog.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/core/utils/calculate_reading_time.dart';
import 'package:posbinduptm/core/utils/format_date.dart';
import 'package:posbinduptm/features/blog/domain/entities/blog_entity.dart';
import 'package:posbinduptm/features/blog/presentation/pages/update_blog_page.dart';
import '../bloc/blog_bloc.dart';

class BlogViewerPage extends StatefulWidget {
  final BlogEntity blog;
  final VoidCallback? onUpdated;

  const BlogViewerPage({super.key, required this.blog, this.onUpdated});

  static Route route(BlogEntity blog, {VoidCallback? onUpdated}) {
    return MaterialPageRoute(
      builder: (context) => BlogViewerPage(blog: blog, onUpdated: onUpdated),
    );
  }

  @override
  State<BlogViewerPage> createState() => _BlogViewerPageState();
}

class _BlogViewerPageState extends State<BlogViewerPage> {
  late BlogEntity blog;

  @override
  void initState() {
    super.initState();
    blog = widget.blog;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogDeleteSuccess) {
          widget.onUpdated?.call();
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is BlogUpdateSuccess && state.updatedBlog.id == blog.id) {
          blog = state.updatedBlog;
        }

        return Scaffold(
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
                icon: const Icon(Icons.delete_outline_outlined,
                    color: Colors.red),
                onPressed: () => _showDeleteDialog(context, blog.id),
              ),
              IconButton(
                onPressed: () async {
                  debugPrint(
                      " Navigasi ke UpdateBlogPage dengan ID: ${blog.id}");

                  final updatedBlog = await Navigator.push<BlogEntity>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateBlogPage(blog: blog),
                    ),
                  );

                  if (!context.mounted) return;

                  if (updatedBlog != null) {
                    debugPrint("✅ Data terbaru diterima: ${updatedBlog.title}");
                    setState(() {
                      blog = updatedBlog;
                    });
                    widget.onUpdated?.call();
                  }
                },
                icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'by ${blog.posterName}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppPallete.greyColor,
                  ),
                ),
                Text(
                  '${formatDateBydMMMMYYYY(blog.updatedAt)} • ${calculateReadingTime(blog.content)} min read',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    '${blog.imageUrl}?${DateTime.now().millisecondsSinceEpoch}',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
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
        );
      },
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

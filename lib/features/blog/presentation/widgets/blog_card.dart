import 'package:flutter/material.dart';
import 'package:posbinduptm/core/utils/calculate_reading_time.dart';
import 'package:posbinduptm/features/blog/domain/entities/blog_entity.dart';
import 'package:posbinduptm/features/blog/presentation/pages/blog_viewer_page.dart';

class BlogCard extends StatelessWidget {
  final BlogEntity blog;
  final Color color;
  final VoidCallback? onUpdated;

  const BlogCard({
    super.key,
    required this.blog,
    required this.color,
    this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          BlogViewerPage.route(blog, onUpdated: onUpdated), // ✅ Kirim onUpdated
        );

        if (!context.mounted) return;
        onUpdated?.call(); // ✅ Perbarui daftar blog setelah kembali ke BlogPage
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.8), // **Outline mengikuti warna utama**
            width: 1.5, // Lebar border
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2), // **Bayangan sedikit berwarna**
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **TOPICS (Kategori Blog)**
            if (blog.topics.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: blog.topics
                      .map(
                        (e) => Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            e,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

            const SizedBox(height: 8),

            // **TITLE**
            Text(
              blog.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // **FOOTER: Reading Time**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${calculateReadingTime(blog.content)} min read',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

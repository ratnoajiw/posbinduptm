part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUpload extends BlogEvent {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  BlogUpload({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}

class BlogUpdate extends BlogEvent {
  final String blogId;
  final String title;
  final String content;
  final File? image;
  final List<String> topics;
  final String posterId;
  final String? posterName;
  final String? imageUrl;

  BlogUpdate({
    required this.blogId,
    required this.title,
    required this.content,
    this.image,
    required this.topics,
    required this.posterId,
    this.posterName,
    this.imageUrl,
  }) {
    debugPrint("🟢 Event BlogUpdate dijalankan dengan parameter:");
    debugPrint("📌 blogId: $blogId");
    debugPrint("📌 title: $title");
    debugPrint(
        "📌 content: ${content.substring(0, content.length > 20 ? 20 : content.length)}...");
    debugPrint("📌 topics: $topics");
    debugPrint("📌 posterId: $posterId");
    debugPrint(
        "📌 image: ${image != null ? "Ada gambar baru" : "Tidak ada perubahan gambar"}");
  }
}

class BlogGetAllBlogs extends BlogEvent {
  final String posterId;

  BlogGetAllBlogs({required this.posterId});
}

class BlogDelete extends BlogEvent {
  final String blogId;

  BlogDelete({required this.blogId});
}

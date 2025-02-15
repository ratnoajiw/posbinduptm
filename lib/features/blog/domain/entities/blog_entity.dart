class BlogEntity {
  final String id;
  final String posterId;
  final String title;
  final String content;
  final String imageUrl;
  final List<String> topics;
  final DateTime updatedAt;
  final String? posterName;

  BlogEntity({
    required this.id,
    required this.posterId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
    required this.updatedAt,
    this.posterName,
  });

  BlogEntity copyWith({
    String? title,
    String? content,
    List<String>? topics,
    String? imageUrl,
    String? posterName,
  }) {
    return BlogEntity(
      title: title ?? this.title,
      content: content ?? this.content,
      topics: topics ?? this.topics,
      imageUrl: imageUrl ?? this.imageUrl,
      id: id,
      posterId: posterId,
      updatedAt: updatedAt,
      posterName: posterName ?? this.posterName,
    );
  }
}

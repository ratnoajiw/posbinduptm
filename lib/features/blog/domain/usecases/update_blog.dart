import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/blog/domain/entities/blog_entity.dart';
import 'package:posbinduptm/features/blog/domain/repositories/blog_repository.dart';

class UpdateBlog implements UseCase<BlogEntity, UpdateBlogParams> {
  final BlogRepository repository;

  UpdateBlog(this.repository);

  @override
  Future<Either<Failure, BlogEntity>> call(UpdateBlogParams params) {
    return repository.updateBlog(
      blogId: params.blogId,
      title: params.title,
      content: params.content,
      topics: params.topics,
      image: params.image,
      posterId: params.posterId,
    );
  }
}

class UpdateBlogParams {
  final String blogId;
  final String title;
  final String content;
  final List<String> topics;
  final File? image;
  final String posterId;

  UpdateBlogParams({
    required this.blogId,
    required this.title,
    required this.content,
    required this.topics,
    required this.posterId,
    this.image,
  });
}

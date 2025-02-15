import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/features/blog/domain/entities/blog_entity.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, BlogEntity>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });

  Future<Either<Failure, BlogEntity>> updateBlog({
    required String blogId,
    required String title,
    required String content,
    required List<String> topics,
    required String posterId,
    File? image, // opsional
  });

  Future<Either<Failure, void>> deleteBlog(
    String blogId,
  );

  Future<Either<Failure, List<BlogEntity>>> getAllBlogs({
    required String posterId,
  });
}

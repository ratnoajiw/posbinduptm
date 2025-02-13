import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/constants/constants.dart';
import 'package:posbinduptm/core/error/exceptions.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/network/connection_checker.dart';
// import 'package:posbinduptm/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:posbinduptm/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:posbinduptm/features/blog/data/models/blog_model.dart';
import 'package:posbinduptm/features/blog/domain/entities/blog_entity.dart';
import 'package:posbinduptm/features/blog/domain/repositories/blog_repository.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final ConnectionChecker connectionChecker;

  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    this.connectionChecker,
  );
  @override
  Future<Either<Failure, BlogEntity>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
        posterName: '',
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogimage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<BlogEntity>>> getAllBlogs(
      {required String posterId}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        // final blogs = blogLocalDataSource.loadBlogs();
        // return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs(posterId: posterId);
      // blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBlog(String blogId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      await blogRemoteDataSource.deleteBlog(blogId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}

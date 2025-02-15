import 'dart:io';

import 'package:flutter/material.dart';
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
  Future<Either<Failure, BlogEntity>> updateBlog({
    required String blogId,
    required String title,
    required String content,
    required List<String> topics,
    required String posterId,
    File? image,
  }) async {
    debugPrint(
        "📝 Repository menerima permintaan update untuk blog ID: $blogId oleh posterId: $posterId");

    // Validasi ID
    if (blogId.isEmpty || posterId.isEmpty) {
      debugPrint("⚠️ Blog ID atau Poster ID kosong.");
      return left(Failure("Blog ID atau Poster ID tidak valid."));
    }

    try {
      if (!await connectionChecker.isConnected) {
        debugPrint("⚠️ Tidak ada koneksi internet.");
        return left(Failure(Constant.noConnectionErrorMessage));
      }

      // Ambil blog dari database
      final blog = await blogRemoteDataSource.getBlogById(
          blogId: blogId, posterId: posterId);

      if (blog == null) {
        debugPrint(
            "❌ Blog dengan ID: $blogId tidak ditemukan untuk posterId: $posterId.");
        return left(Failure("Blog tidak ditemukan atau bukan milik Anda."));
      }

      debugPrint("✅ Blog ditemukan: ${blog.id}, title: ${blog.title}");

      String imageUrl = blog.imageUrl;

      // Jika ada gambar baru, hapus gambar lama lalu upload gambar baru
      if (image != null) {
        debugPrint("📸 Menghapus gambar lama dan mengunggah gambar baru...");
        await blogRemoteDataSource.deleteBlogImage(blog.id);
        imageUrl = await blogRemoteDataSource.uploadBlogimage(
          image: image,
          blog: blog,
        );
        debugPrint("✅ Gambar baru diunggah: $imageUrl");
      }

      // Buat model blog yang diperbarui
      final updatedBlogModel = blog.copyWith(
        title: title,
        content: content,
        topics: topics,
        imageUrl: imageUrl,
        updatedAt: DateTime.now(),
      );

      debugPrint("🔄 Mengupdate blog ke database...");

      // Kirim ke remote data source
      final updatedBlog =
          await blogRemoteDataSource.updateBlog(updatedBlogModel);

      debugPrint("✅ Blog berhasil diperbarui!");
      return right(updatedBlog);
    } on ServerException catch (e) {
      debugPrint("❌ ServerException terjadi: ${e.message}");
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

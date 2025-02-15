import 'dart:io';

import 'package:flutter/material.dart';
import 'package:posbinduptm/core/error/exceptions.dart';
import 'package:posbinduptm/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:collection/collection.dart';

abstract interface class BlogRemoteDataSource {
  // Menampilkan semua blog berdasarkan posterId
  Future<List<BlogModel>> getAllBlogs({
    required String posterId,
  });

  // Menampilkan satu blog berdasarkan blogId dan posterId
  Future<BlogModel?> getBlogById({
    required String blogId,
    required String posterId,
  });

  // Upload blog baru
  Future<BlogModel> uploadBlog(
    BlogModel blog,
  );

  // Upload gambar blog
  Future<String> uploadBlogimage({
    required File image,
    required BlogModel blog,
  });

  // Update blog
  Future<BlogModel> updateBlog(
    BlogModel blog,
  );

  // Hapus gambar blog
  Future<void> deleteBlogImage(String blogId);

  // Hapus blog
  Future<void> deleteBlog(String blogId);
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl(
    this.supabaseClient,
  );

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from('blogs').insert(blog.toJson()).select();
      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogimage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      // 🔹 Hapus gambar lama sebelum upload baru
      await deleteBlogImage(blog.id);

      // 🔹 Buat nama file unik
      final String uniqueFileName =
          '${blog.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // 🔹 Upload gambar baru dengan nama unik
      await supabaseClient.storage.from('blog_images').upload(
            uniqueFileName,
            image,
            fileOptions:
                const FileOptions(upsert: true), // ✅ Pastikan file bisa diganti
          );

      // 🔹 Dapatkan URL gambar baru
      return supabaseClient.storage
          .from('blog_images')
          .getPublicUrl(uniqueFileName);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteBlogImage(String blogId) async {
    try {
      // 🔹 Ambil daftar file di bucket 'blog_images'
      final List<FileObject> existingFiles =
          await supabaseClient.storage.from('blog_images').list();

      // 🔎 Cari file yang cocok dengan blogId
      final fileToDelete = existingFiles.firstWhereOrNull(
        (file) => file.name.startsWith(blogId),
      );

      if (fileToDelete != null) {
        // 🔹 Hapus file jika ditemukan
        await supabaseClient.storage
            .from('blog_images')
            .remove([fileToDelete.name]);
        debugPrint("✅ Gambar lama berhasil dihapus: ${fileToDelete.name}");
      } else {
        debugPrint(
            "⚠ Tidak ada gambar lama yang ditemukan untuk blogId: $blogId");
      }
    } catch (e) {
      throw ServerException("Failed to delete old blog image: ${e.toString()}");
    }
  }

  @override
  Future<BlogModel> updateBlog(BlogModel blog) async {
    try {
      if (blog.id.isEmpty) {
        throw const ServerException("Error: Blog ID tidak valid.");
      }

      // 🔹 Simpan data yang akan di-update
      final updateData = {
        'title': blog.title,
        'content': blog.content,
        'topics': blog.topics,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // 🔹 Jika gambar baru ada, update `image_url`
      if (blog.imageUrl.isNotEmpty) {
        updateData['image_url'] = blog.imageUrl;
      }

      final updatedData = await supabaseClient
          .from('blogs')
          .update(updateData)
          .match({'id': blog.id, 'poster_id': blog.posterId}).select();

      return BlogModel.fromJson(updatedData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BlogModel?> getBlogById(
      {required String blogId, required String posterId}) async {
    try {
      final blogs = await supabaseClient
          .from('blogs')
          .select('*')
          .eq('id', blogId)
          .eq('poster_id', posterId)
          .limit(1);

      if (blogs.isEmpty) return null;
      return BlogModel.fromJson(blogs.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<void> deleteBlog(String blogId) async {
    try {
      await supabaseClient.from('blogs').delete().match({
        'id': blogId,
      });
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs({required String posterId}) async {
    try {
      final blogs = await supabaseClient
          .from('blogs')
          .select('*, profiles(name)')
          .eq('poster_id', posterId);

      return blogs.map((blog) {
        return BlogModel.fromJson(blog).copyWith(
          posterName: blog['profiles'] != null
              ? blog['profiles']['name']
              : null, // ✅ Cegah error jika profiles null
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }
}

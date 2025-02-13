import 'dart:io';

import 'package:posbinduptm/core/error/exceptions.dart';
import 'package:posbinduptm/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  //menampilkan data upload
  Future<List<BlogModel>> getAllBlogs({
    required String posterId,
  });
  //upload blog
  Future<BlogModel> uploadBlog(
    BlogModel blog,
  );
  //upload gambar
  Future<String> uploadBlogimage({
    required File image,
    required BlogModel blog,
  });

  //delete blog
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
      await supabaseClient.storage.from('blog_images').upload(
            blog.id,
            image,
          );
      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
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
          .eq('poster_id', posterId); // Hanya blog milik user tertentu

      return blogs.map((blog) {
        return BlogModel.fromJson(blog).copyWith(
          posterName: blog['profiles']
              ?['name'], // Pastikan 'profiles' tidak null
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }
}

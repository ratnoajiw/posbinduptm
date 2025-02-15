import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/features/blog/domain/entities/blog_entity.dart';
import 'package:posbinduptm/features/blog/domain/usecases/delete_blog.dart';
import 'package:posbinduptm/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:posbinduptm/features/blog/domain/usecases/update_blog.dart';
import 'package:posbinduptm/features/blog/domain/usecases/upload_blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  //panggil usecase
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final DeleteBlog _deleteBlog;
  final UpdateBlog _updateBlog;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
    required DeleteBlog deleteBlog,
    required UpdateBlog updateBlog,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        _deleteBlog = deleteBlog,
        _updateBlog = updateBlog,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogGetAllBlogs>(_onGetAllblogs);
    on<BlogDelete>(_onDeleteBlog);
    on<BlogUpdate>(_onUpdateBlog);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _onGetAllblogs(BlogGetAllBlogs event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(GetAllBlogsParams(posterId: event.posterId));

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogsDisplaySuccess(r)),
    );
  }

  void _onDeleteBlog(BlogDelete event, Emitter<BlogState> emit) async {
    final res = await _deleteBlog(DeleteBlogParams(blogId: event.blogId));

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogDeleteSuccess()),
    );
  }

  void _onUpdateBlog(BlogUpdate event, Emitter<BlogState> emit) async {
    debugPrint("🟢 Event BlogUpdate diterima di Bloc.");
    debugPrint("📌 blogId: ${event.blogId}");
    debugPrint("📌 title: ${event.title}");
    debugPrint(
        "📌 content: ${event.content.substring(0, event.content.length > 20 ? 20 : event.content.length)}...");
    debugPrint("📌 topics: ${event.topics}");
    debugPrint("📌 posterId: ${event.posterId}");
    debugPrint(
        "📌 image: ${event.image != null ? "Ada gambar baru" : "Tidak ada perubahan gambar"}");

    emit(BlogLoading());

    final res = await _updateBlog(UpdateBlogParams(
      blogId: event.blogId,
      title: event.title,
      content: event.content,
      image: event.image,
      topics: event.topics,
      posterId: event.posterId,
    ));

    res.fold(
      (l) {
        debugPrint("❌ Gagal update blog: ${l.message}");
        emit(BlogFailure(l.message));
      },
      (r) {
        debugPrint("✅ Berhasil update blog dengan ID: ${r.id}");
        emit(BlogUpdateSuccess(r)); // ✅ Menggunakan r, bukan updatedBlog
      },
    );
  }
}

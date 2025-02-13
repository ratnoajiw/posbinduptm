import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/blog/domain/repositories/blog_repository.dart';

class DeleteBlog implements UseCase<void, DeleteBlogParams> {
  final BlogRepository repository;

  DeleteBlog(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteBlogParams params) {
    return repository.deleteBlog(params.blogId);
  }
}

class DeleteBlogParams {
  final String blogId;

  DeleteBlogParams({required this.blogId});
}

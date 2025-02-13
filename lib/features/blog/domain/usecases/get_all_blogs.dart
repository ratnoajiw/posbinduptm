import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/blog/domain/entities/blog_entity.dart';
import 'package:posbinduptm/features/blog/domain/repositories/blog_repository.dart';

class GetAllBlogs implements UseCase<List<BlogEntity>, GetAllBlogsParams> {
  final BlogRepository blogRepository;

  GetAllBlogs(this.blogRepository);

  @override
  Future<Either<Failure, List<BlogEntity>>> call(
      GetAllBlogsParams params) async {
    return await blogRepository.getAllBlogs(
      posterId: params.posterId,
    );
  }
}

class GetAllBlogsParams {
  final String posterId;

  GetAllBlogsParams({required this.posterId});
}

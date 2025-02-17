import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/repository/gula_darah_repository.dart';

class DeleteGulaDarah implements UseCase<void, DeleteGulaDarahParams> {
  final GulaDarahRepository repository;

  DeleteGulaDarah(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteGulaDarahParams params) {
    return repository.deleteGulaDarah(params.id);
  }
}

class DeleteGulaDarahParams {
  final String id;

  DeleteGulaDarahParams({required this.id});
}

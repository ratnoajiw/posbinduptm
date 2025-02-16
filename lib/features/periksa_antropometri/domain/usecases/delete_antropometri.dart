import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_antropometri/domain/repositories/antropometri_repository.dart';

class DeleteAntropometri implements UseCase<void, DeleteAntropometriParams> {
  final AntropometriRepository repository;

  DeleteAntropometri(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteAntropometriParams params) {
    return repository.deleteAntropometri(params.antropometriId);
  }
}

class DeleteAntropometriParams {
  final String antropometriId;

  DeleteAntropometriParams({required this.antropometriId});
}

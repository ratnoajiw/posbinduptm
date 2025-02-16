import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/repository/gula_darah_repository.dart';

class DeletePeriksaGulaDarah
    implements UseCase<void, DeletePeriksaGulaDarahParams> {
  final PeriksaGulaDarahRepository repository;

  DeletePeriksaGulaDarah(this.repository);

  @override
  Future<Either<Failure, void>> call(DeletePeriksaGulaDarahParams params) {
    return repository.deletePeriksaGulaDarah(params.id);
  }
}

class DeletePeriksaGulaDarahParams {
  final String id;

  DeletePeriksaGulaDarahParams({required this.id});
}

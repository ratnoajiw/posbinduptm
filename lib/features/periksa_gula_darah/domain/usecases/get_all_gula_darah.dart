import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/gula_darah_entity.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/repository/gula_darah_repository.dart';

class GetAllPeriksaGulaDarah
    implements
        UseCase<List<PeriksaGulaDarahEntity>, GetAllPeriksaGulaDarahParams> {
  final PeriksaGulaDarahRepository repository;

  GetAllPeriksaGulaDarah(this.repository);

  @override
  Future<Either<Failure, List<PeriksaGulaDarahEntity>>> call(
      GetAllPeriksaGulaDarahParams params) {
    return repository.getAllPeriksaGulaDarah(profileId: params.profileId);
  }
}

class GetAllPeriksaGulaDarahParams {
  final String profileId;

  GetAllPeriksaGulaDarahParams({required this.profileId});
}

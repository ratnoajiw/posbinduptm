import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/gula_darah_entity.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/repository/gula_darah_repository.dart';

class GetLatestPeriksaGulaDarah
    implements
        UseCase<PeriksaGulaDarahEntity?, GetLatestPeriksaGulaDarahParams> {
  final PeriksaGulaDarahRepository repository;

  GetLatestPeriksaGulaDarah(this.repository);

  @override
  Future<Either<Failure, PeriksaGulaDarahEntity?>> call(
      GetLatestPeriksaGulaDarahParams params) {
    return repository.getLatestPeriksaGulaDarah(profileId: params.profileId);
  }
}

class GetLatestPeriksaGulaDarahParams {
  final String profileId;

  GetLatestPeriksaGulaDarahParams({required this.profileId});
}

import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/gula_darah_entity.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/repository/gula_darah_repository.dart';

class GetLatestGulaDarah
    implements UseCase<GulaDarahEntity?, GetLatestGulaDarahParams> {
  final GulaDarahRepository repository;

  GetLatestGulaDarah(this.repository);

  @override
  Future<Either<Failure, GulaDarahEntity?>> call(
      GetLatestGulaDarahParams params) {
    return repository.getLatestGulaDarah(profileId: params.profileId);
  }
}

class GetLatestGulaDarahParams {
  final String profileId;

  GetLatestGulaDarahParams({required this.profileId});
}

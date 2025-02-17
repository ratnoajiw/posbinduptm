import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/gula_darah_entity.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/repository/gula_darah_repository.dart';

class GetAllGulaDarah
    implements UseCase<List<GulaDarahEntity>, GetAllGulaDarahParams> {
  final GulaDarahRepository repository;

  GetAllGulaDarah(this.repository);

  @override
  Future<Either<Failure, List<GulaDarahEntity>>> call(
      GetAllGulaDarahParams params) {
    return repository.getAllGulaDarah(profileId: params.profileId);
  }
}

class GetAllGulaDarahParams {
  final String profileId;

  GetAllGulaDarahParams({required this.profileId});
}

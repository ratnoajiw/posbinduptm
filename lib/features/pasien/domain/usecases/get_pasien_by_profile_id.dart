import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/pasien/domain/entities/pasien_entity.dart';
import 'package:posbinduptm/features/pasien/domain/repositories/pasien_repository.dart';

class GetPasienByProfileId
    implements UseCase<PasienEntity?, GetPasienByProfileIdParams> {
  final PasienRepository repository;

  GetPasienByProfileId(this.repository);

  @override
  Future<Either<Failure, PasienEntity?>> call(
      GetPasienByProfileIdParams params) async {
    return await repository.getPasienByProfileId(profileId: params.profileId);
  }
}

class GetPasienByProfileIdParams {
  final String profileId;

  GetPasienByProfileIdParams({required this.profileId});
}

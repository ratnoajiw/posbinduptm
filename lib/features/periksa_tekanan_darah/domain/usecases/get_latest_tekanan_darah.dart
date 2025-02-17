import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/entities/tekanan_darah_entity.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/repositories/tekanan_darah_repository.dart';

class GetLatestTekananDarah
    implements UseCase<TekananDarahEntity?, GetLatestTekananDarahParams> {
  final TekananDarahRepository repository;

  GetLatestTekananDarah(this.repository);

  @override
  Future<Either<Failure, TekananDarahEntity?>> call(
      GetLatestTekananDarahParams params) async {
    return await repository.getLatestTekananDarah(profileId: params.profileId);
  }
}

class GetLatestTekananDarahParams {
  final String profileId;

  GetLatestTekananDarahParams({required this.profileId});
}

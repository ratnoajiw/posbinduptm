import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/entities/tekanan_darah_entity.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/repositories/tekanan_darah_repository.dart';

class GetAllTekananDarah
    implements UseCase<List<TekananDarahEntity>, GetAllTekananDarahParams> {
  final TekananDarahRepository repository;

  GetAllTekananDarah(this.repository);

  @override
  Future<Either<Failure, List<TekananDarahEntity>>> call(
      GetAllTekananDarahParams params) async {
    return await repository.getAllTekananDarah(profileId: params.profileId);
  }
}

class GetAllTekananDarahParams {
  final String profileId;

  GetAllTekananDarahParams({required this.profileId});
}

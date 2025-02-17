import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/entities/kolesterol_total_entity.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/repositories/kolesterol_total_repository.dart';

class GetAllKolesterolTotal
    implements
        UseCase<List<KolesterolTotalEntity>, GetAllKolesterolTotalParams> {
  final KolesterolTotalRepository repository;

  GetAllKolesterolTotal(this.repository);

  @override
  Future<Either<Failure, List<KolesterolTotalEntity>>> call(
      GetAllKolesterolTotalParams params) async {
    return await repository.getAllKolesterolTotal(profileId: params.profileId);
  }
}

class GetAllKolesterolTotalParams {
  final String profileId;

  GetAllKolesterolTotalParams({required this.profileId});
}

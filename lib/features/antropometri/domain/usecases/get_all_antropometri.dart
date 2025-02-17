import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/antropometri/domain/entities/antropometri_entity.dart';
import 'package:posbinduptm/features/antropometri/domain/repositories/antropometri_repository.dart';

class GetAllAntropometri
    implements UseCase<List<AntropometriEntity>, GetAllAntropometriParams> {
  final AntropometriRepository antropometriRepository;

  GetAllAntropometri(
    this.antropometriRepository, {
    required String posterId,
  });

  @override
  Future<Either<Failure, List<AntropometriEntity>>> call(
      GetAllAntropometriParams params) async {
    return await antropometriRepository.getAllAntropometri(
      posterId: params.posterId,
    );
  }
}

class GetAllAntropometriParams {
  final String posterId;

  GetAllAntropometriParams({required this.posterId});
}

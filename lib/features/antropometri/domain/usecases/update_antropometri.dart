import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/antropometri/domain/repositories/antropometri_repository.dart';

class UpdateAntropometri implements UseCase<void, UpdateAntropometriParams> {
  final AntropometriRepository repository;

  UpdateAntropometri(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateAntropometriParams params) {
    return repository.updateAntropometri(
      id: params.id,
      tinggiBadan: params.tinggiBadan,
      beratBadan: params.beratBadan,
      lingkarPerut: params.lingkarPerut,
    );
  }
}

class UpdateAntropometriParams {
  final String id;
  final double tinggiBadan;
  final double beratBadan;
  final double lingkarPerut;

  UpdateAntropometriParams({
    required this.id,
    required this.tinggiBadan,
    required this.beratBadan,
    required this.lingkarPerut,
  });
}

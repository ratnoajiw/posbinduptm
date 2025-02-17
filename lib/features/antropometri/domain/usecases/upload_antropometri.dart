import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/antropometri/domain/entities/antropometri_entity.dart';
import 'package:posbinduptm/features/antropometri/domain/repositories/antropometri_repository.dart';

class UploadAntropometri
    implements UseCase<AntropometriEntity, UploadAntropometriParams> {
  final AntropometriRepository antropometriRepository;
  UploadAntropometri(this.antropometriRepository);

  @override
  Future<Either<Failure, AntropometriEntity>> call(params) async {
    return await antropometriRepository.uploadAntropometri(
      tinggiBadan: params.tinggiBadan,
      beratBadan: params.beratBadan,
      lingkarPerut: params.lingkarPerut,
      posterId: params.posterId,
      pemeriksaanAt: params.pemeriksaanAt,
    );
  }
}

class UploadAntropometriParams {
  final double tinggiBadan;
  final double beratBadan;
  final double lingkarPerut;
  final String posterId;
  final DateTime pemeriksaanAt;

  UploadAntropometriParams({
    required this.tinggiBadan,
    required this.beratBadan,
    required this.lingkarPerut,
    required this.posterId,
    required this.pemeriksaanAt,
  });
}

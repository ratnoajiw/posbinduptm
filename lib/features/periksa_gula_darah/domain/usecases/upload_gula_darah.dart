import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/gula_darah_entity.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/repository/gula_darah_repository.dart';

class UploadPeriksaGulaDarah
    implements UseCase<PeriksaGulaDarahEntity, UploadPeriksaGulaDarahParams> {
  final PeriksaGulaDarahRepository repository;

  UploadPeriksaGulaDarah(this.repository);

  @override
  Future<Either<Failure, PeriksaGulaDarahEntity>> call(params) async {
    return await repository.uploadPeriksaGulaDarah(
      profileId: params.profileId,
      gulaDarahSewaktu: params.gulaDarahSewaktu,
      pemeriksaanAt: params.pemeriksaanAt,
    );
  }
}

class UploadPeriksaGulaDarahParams {
  final String profileId;
  final double gulaDarahSewaktu;
  final DateTime pemeriksaanAt;

  UploadPeriksaGulaDarahParams({
    required this.gulaDarahSewaktu,
    required this.profileId,
    required this.pemeriksaanAt,
  });
}

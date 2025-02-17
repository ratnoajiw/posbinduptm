import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/gula_darah_entity.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/repository/gula_darah_repository.dart';

class UploadGulaDarah
    implements UseCase<GulaDarahEntity, UploadGulaDarahParams> {
  final GulaDarahRepository repository;

  UploadGulaDarah(this.repository);

  @override
  Future<Either<Failure, GulaDarahEntity>> call(params) async {
    return await repository.uploadGulaDarah(
      profileId: params.profileId,
      gulaDarahSewaktu: params.gulaDarahSewaktu,
      pemeriksaanAt: params.pemeriksaanAt,
    );
  }
}

class UploadGulaDarahParams {
  final String profileId;
  final double gulaDarahSewaktu;
  final DateTime pemeriksaanAt;

  UploadGulaDarahParams({
    required this.gulaDarahSewaktu,
    required this.profileId,
    required this.pemeriksaanAt,
  });
}

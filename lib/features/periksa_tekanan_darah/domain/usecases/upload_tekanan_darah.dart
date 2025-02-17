import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/entities/tekanan_darah_entity.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/repositories/tekanan_darah_repository.dart';

class UploadTekananDarah
    implements UseCase<TekananDarahEntity, UploadTekananDarahParams> {
  final TekananDarahRepository repository;

  UploadTekananDarah(this.repository);

  @override
  Future<Either<Failure, TekananDarahEntity>> call(
      UploadTekananDarahParams params) async {
    return await repository.uploadTekananDarah(
      profileId: params.profileId,
      sistolik: params.sistolik,
      diastolik: params.diastolik,
      pemeriksaanAt: params.pemeriksaanAt,
    );
  }
}

class UploadTekananDarahParams {
  final String profileId;
  final double sistolik;
  final double diastolik;
  final DateTime pemeriksaanAt;

  UploadTekananDarahParams({
    required this.profileId,
    required this.sistolik,
    required this.diastolik,
    required this.pemeriksaanAt,
  });
}

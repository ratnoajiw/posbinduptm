import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/entities/tekanan_darah_entity.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/repositories/tekanan_darah_repository.dart';

class UpdateTekananDarah
    implements UseCase<TekananDarahEntity, UpdateTekananDarahParams> {
  final TekananDarahRepository repository;

  UpdateTekananDarah(this.repository);

  @override
  Future<Either<Failure, TekananDarahEntity>> call(
      UpdateTekananDarahParams params) async {
    return await repository.updateTekananDarah(
      tekananDarahId: params.tekananDarahId,
      sistolik: params.sistolik,
      diastolik: params.diastolik,
      pemeriksaanAt: params.pemeriksaanAt,
    );
  }
}

class UpdateTekananDarahParams {
  final String tekananDarahId;
  final double sistolik;
  final double diastolik;
  final DateTime pemeriksaanAt;

  UpdateTekananDarahParams({
    required this.tekananDarahId,
    required this.sistolik,
    required this.diastolik,
    required this.pemeriksaanAt,
  });
}

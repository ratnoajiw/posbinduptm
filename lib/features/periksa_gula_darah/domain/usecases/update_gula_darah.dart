import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/gula_darah_entity.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/repository/gula_darah_repository.dart';

class UpdateGulaDarah
    implements UseCase<GulaDarahEntity, UpdateGulaDarahParams> {
  final GulaDarahRepository repository;

  UpdateGulaDarah(this.repository);

  @override
  Future<Either<Failure, GulaDarahEntity>> call(
      UpdateGulaDarahParams params) async {
    return await repository.updateGulaDarah(
      gulaDarahId: params.gulaDarahId,
      gulaDarahSewaktu: params.gulaDarahSewaktu,
      pemeriksaanAt: params.pemeriksaanAt,
    );
  }
}

class UpdateGulaDarahParams {
  final String gulaDarahId;
  final double gulaDarahSewaktu;
  final DateTime pemeriksaanAt;

  UpdateGulaDarahParams({
    required this.gulaDarahId,
    required this.gulaDarahSewaktu,
    required this.pemeriksaanAt,
  });
}

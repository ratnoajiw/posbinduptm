import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/gula_darah_entity.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/repository/gula_darah_repository.dart';

class UpdatePeriksaGulaDarah
    implements UseCase<PeriksaGulaDarahEntity, UpdatePeriksaGulaDarahParams> {
  final PeriksaGulaDarahRepository repository;

  UpdatePeriksaGulaDarah(this.repository);

  @override
  Future<Either<Failure, PeriksaGulaDarahEntity>> call(
      UpdatePeriksaGulaDarahParams params) async {
    return await repository.updatePeriksaGulaDarah(
      id: params.id,
      gulaDarahSewaktu: params.gulaDarahSewaktu,
      pemeriksaanAt: params.pemeriksaanAt,
    );
  }
}

class UpdatePeriksaGulaDarahParams {
  final String id;
  final double gulaDarahSewaktu;
  final DateTime pemeriksaanAt;

  UpdatePeriksaGulaDarahParams({
    required this.id,
    required this.gulaDarahSewaktu,
    required this.pemeriksaanAt,
  });
}

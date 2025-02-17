import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/entities/kolesterol_total_entity.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/repositories/kolesterol_total_repository.dart';

class UpdateKolesterolTotal
    implements UseCase<KolesterolTotalEntity, UpdateKolesterolTotalParams> {
  final KolesterolTotalRepository repository;

  UpdateKolesterolTotal(this.repository);

  @override
  Future<Either<Failure, KolesterolTotalEntity>> call(
      UpdateKolesterolTotalParams params) async {
    return await repository.updateKolesterolTotal(
      kolesterolTotalId: params.kolesterolTotalId,
      kolesterolTotal: params.kolesterolTotal,
      pemeriksaanAt: params.pemeriksaanAt,
    );
  }
}

class UpdateKolesterolTotalParams {
  final String kolesterolTotalId;
  final double kolesterolTotal;
  final DateTime pemeriksaanAt;

  UpdateKolesterolTotalParams({
    required this.kolesterolTotalId,
    required this.kolesterolTotal,
    required this.pemeriksaanAt,
  });
}

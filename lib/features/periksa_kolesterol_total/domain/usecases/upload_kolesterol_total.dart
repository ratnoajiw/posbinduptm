import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/entities/kolesterol_total_entity.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/repositories/kolesterol_total_repository.dart';

class UploadKolesterolTotal
    implements UseCase<KolesterolTotalEntity, UploadKolesterolTotalParams> {
  final KolesterolTotalRepository repository;

  UploadKolesterolTotal(this.repository);

  @override
  Future<Either<Failure, KolesterolTotalEntity>> call(
      UploadKolesterolTotalParams params) async {
    return await repository.uploadKolesterolTotal(
      profileId: params.profileId,
      kolesterolTotal: params.kolesterolTotal,
      pemeriksaanAt: params.pemeriksaanAt,
    );
  }
}

class UploadKolesterolTotalParams {
  final String profileId;
  final double kolesterolTotal;
  final DateTime pemeriksaanAt;

  UploadKolesterolTotalParams({
    required this.profileId,
    required this.kolesterolTotal,
    required this.pemeriksaanAt,
  });
}

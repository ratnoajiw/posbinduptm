import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/features/periksa_antropometri/domain/entities/antropometri_entity.dart';

//upload (create) antropometri
abstract interface class AntropometriRepository {
  Future<Either<Failure, AntropometriEntity>> uploadAntropometri({
    required String posterId,
    required double tinggiBadan,
    required double beratBadan,
    required double lingkarPerut,
    required DateTime pemeriksaanAt,
  });
//get all (read) antropometri
  Future<Either<Failure, List<AntropometriEntity>>> getAllAntropometri({
    required String posterId,
  });

//update antropometri
  Future<Either<Failure, void>> updateAntropometri({
    required String id,
    required double tinggiBadan,
    required double beratBadan,
    required double lingkarPerut,
    required DateTime pemeriksaanAt,
  });
//delete antropometri
  Future<Either<Failure, void>> deleteAntropometri(
    String antropometriId,
  );
}

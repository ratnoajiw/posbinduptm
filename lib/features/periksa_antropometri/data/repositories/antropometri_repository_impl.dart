import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/constants/constants.dart';
import 'package:posbinduptm/core/error/exceptions.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/network/connection_checker.dart';
import 'package:posbinduptm/features/periksa_antropometri/data/datasources/antropometri_remote_data_source.dart';
import 'package:posbinduptm/features/periksa_antropometri/data/models/antropometri_model.dart';
import 'package:posbinduptm/features/periksa_antropometri/domain/entities/antropometri_entity.dart';
import 'package:posbinduptm/features/periksa_antropometri/domain/repositories/antropometri_repository.dart';
import 'package:uuid/uuid.dart';

class AntropometriRepositoryImpl implements AntropometriRepository {
  final AntropometriRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  AntropometriRepositoryImpl(
    this.remoteDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, List<AntropometriEntity>>> getAllAntropometri(
      {required String posterId}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      final antropometris =
          await remoteDataSource.getAllAntropometri(posterId: posterId);
      return right(antropometris);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, AntropometriEntity>> uploadAntropometri({
    required double tinggiBadan,
    required double beratBadan,
    required double lingkarPerut,
    required String posterId,
    required DateTime pemeriksaanAt,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      AntropometriModel antropometriModel = AntropometriModel(
        id: const Uuid().v1(),
        posterId: posterId,
        tinggiBadan: tinggiBadan,
        beratBadan: beratBadan,
        lingkarPerut: lingkarPerut,
        updatedAt: DateTime.now(),
        imtPasien: beratBadan / ((tinggiBadan / 100) * (tinggiBadan / 100)),
        pemeriksaanAt: pemeriksaanAt,
        posterName: '',
      );
      final uploadedAntropometri =
          await remoteDataSource.uploadAntropometri(antropometriModel);
      return right(uploadedAntropometri);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateAntropometri({
    required String id,
    required double tinggiBadan,
    required double beratBadan,
    required double lingkarPerut,
    required DateTime pemeriksaanAt,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      await remoteDataSource.updateAntropometri(
        id: id,
        tinggiBadan: tinggiBadan,
        beratBadan: beratBadan,
        lingkarPerut: lingkarPerut,
        pemeriksaanAt: pemeriksaanAt,
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAntropometri(
      String antropometriId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      await remoteDataSource.deleteAntropometri(antropometriId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}

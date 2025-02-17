import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/constants/constants.dart';
import 'package:posbinduptm/core/error/exceptions.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/network/connection_checker.dart';
import 'package:posbinduptm/features/periksa_gula_darah/data/datasource/gula_darah_remote_data_source.dart';
import 'package:posbinduptm/features/periksa_gula_darah/data/models/gula_darah_model.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/gula_darah_entity.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/repository/gula_darah_repository.dart';
import 'package:uuid/uuid.dart';

class GulaDarahRepositoryImpl implements GulaDarahRepository {
  final GulaDarahRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  GulaDarahRepositoryImpl(
    this.remoteDataSource,
    this.connectionChecker,
  );

  // Ambil semua data pemeriksaan gula darah berdasarkan profileId
  @override
  Future<Either<Failure, List<GulaDarahEntity>>> getAllGulaDarah({
    required String profileId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      final gulaDarahList =
          await remoteDataSource.getAllGulaDarah(profileId: profileId);
      return right(gulaDarahList);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // Ambil data pemeriksaan gula darah terbaru
  @override
  Future<Either<Failure, GulaDarahEntity?>> getLatestGulaDarah({
    required String profileId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      final result =
          await remoteDataSource.getLatestGulaDarah(profileId: profileId);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // Upload data pemeriksaan gula darah
  @override
  Future<Either<Failure, GulaDarahEntity>> uploadGulaDarah({
    required double gulaDarahSewaktu,
    required String profileId,
    required DateTime pemeriksaanAt,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      GulaDarahModel gulaDarahModel = GulaDarahModel(
        gulaDarahId: const Uuid().v1(),
        profileId: profileId,
        gulaDarahSewaktu: gulaDarahSewaktu,
        updatedAt: DateTime.now(),
        pemeriksaanAt: pemeriksaanAt,
      );
      final uploadedGulaDarah =
          await remoteDataSource.uploadGulaDarah(gulaDarahModel);
      return right(uploadedGulaDarah);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // Update data pemeriksaan gula darah berdasarkan ID (mengembalikan entity terbaru)
  @override
  Future<Either<Failure, GulaDarahEntity>> updateGulaDarah({
    required String gulaDarahId,
    required double gulaDarahSewaktu,
    required DateTime pemeriksaanAt,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      final updatedData = await remoteDataSource.updateGulaDarah(
        gulaDarahId: gulaDarahId,
        gulaDarahSewaktu: gulaDarahSewaktu,
        pemeriksaanAt: pemeriksaanAt,
      );
      return right(updatedData);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // Hapus data pemeriksaan gula darah berdasarkan ID
  @override
  Future<Either<Failure, void>> deleteGulaDarah(String gulaDarahId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      await remoteDataSource.deleteGulaDarah(gulaDarahId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}

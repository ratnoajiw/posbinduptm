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

class PeriksaGulaDarahRepositoryImpl implements PeriksaGulaDarahRepository {
  final PeriksaGulaDarahRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  PeriksaGulaDarahRepositoryImpl(
    this.remoteDataSource,
    this.connectionChecker,
  );

  // Ambil semua data pemeriksaan gula darah berdasarkan profileId
  @override
  Future<Either<Failure, List<PeriksaGulaDarahEntity>>> getAllPeriksaGulaDarah({
    required String profileId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      final periksaGulaDarahList =
          await remoteDataSource.getAllPeriksaGulaDarah(profileId: profileId);
      return right(periksaGulaDarahList);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // Ambil data pemeriksaan gula darah terbaru
  @override
  Future<Either<Failure, PeriksaGulaDarahEntity?>> getLatestPeriksaGulaDarah({
    required String profileId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      final result = await remoteDataSource.getLatestPeriksaGulaDarah(
          profileId: profileId);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // Upload data pemeriksaan gula darah
  @override
  Future<Either<Failure, PeriksaGulaDarahEntity>> uploadPeriksaGulaDarah({
    required double gulaDarahSewaktu,
    required String profileId,
    required DateTime pemeriksaanAt,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      PeriksaGulaDarahModel periksaGulaDarahModel = PeriksaGulaDarahModel(
        id: const Uuid().v1(),
        profileId: profileId,
        gulaDarahSewaktu: gulaDarahSewaktu,
        updatedAt: DateTime.now(),
        pemeriksaanAt: pemeriksaanAt,
      );
      final uploadedPeriksaGulaDarah =
          await remoteDataSource.uploadPeriksaGulaDarah(periksaGulaDarahModel);
      return right(uploadedPeriksaGulaDarah);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // Update data pemeriksaan gula darah berdasarkan ID (mengembalikan entity terbaru)
  @override
  Future<Either<Failure, PeriksaGulaDarahEntity>> updatePeriksaGulaDarah({
    required String id,
    required double gulaDarahSewaktu,
    required DateTime pemeriksaanAt,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      final updatedData = await remoteDataSource.updatePeriksaGulaDarah(
        gulaDarahId: id,
        gulaDarahSewaktu: gulaDarahSewaktu,
        periksaAt: pemeriksaanAt,
      );
      return right(updatedData);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // Hapus data pemeriksaan gula darah berdasarkan ID
  @override
  Future<Either<Failure, void>> deletePeriksaGulaDarah(String id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      await remoteDataSource.deletePeriksaGulaDarah(id);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}

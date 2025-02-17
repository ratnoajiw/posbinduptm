import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/constants/constants.dart';
import 'package:posbinduptm/core/error/exceptions.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/network/connection_checker.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/data/datasources/tekanan_darah_remote_data_source.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/data/models/tekanan_darah_model.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/entities/tekanan_darah_entity.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/repositories/tekanan_darah_repository.dart';
import 'package:uuid/uuid.dart';

class TekananDarahRepositoryImpl implements TekananDarahRepository {
  final TekananDarahRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  TekananDarahRepositoryImpl(
    this.remoteDataSource,
    this.connectionChecker,
  );

  // Ambil semua data pemeriksaan tekanan darah berdasarkan profileId
  @override
  Future<Either<Failure, List<TekananDarahEntity>>> getAllTekananDarah({
    required String profileId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      final tekananDarahList =
          await remoteDataSource.getAllTekananDarah(profileId: profileId);
      return right(tekananDarahList);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // Ambil data pemeriksaan tekanan darah terbaru
  @override
  Future<Either<Failure, TekananDarahEntity?>> getLatestTekananDarah({
    required String profileId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      final result =
          await remoteDataSource.getLatestTekananDarah(profileId: profileId);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // Upload data pemeriksaan tekanan darah
  @override
  Future<Either<Failure, TekananDarahEntity>> uploadTekananDarah({
    required double sistolik,
    required double diastolik,
    required String profileId,
    required DateTime pemeriksaanAt,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      TekananDarahModel tekananDarahModel = TekananDarahModel(
        tekananDarahId: const Uuid().v1(),
        profileId: profileId,
        sistolik: sistolik,
        diastolik: diastolik,
        updatedAt: DateTime.now(),
        pemeriksaanAt: pemeriksaanAt,
      );
      final uploadedTekananDarah =
          await remoteDataSource.uploadTekananDarah(tekananDarahModel);
      return right(uploadedTekananDarah);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // Update data pemeriksaan tekanan darah berdasarkan ID (mengembalikan entity terbaru)
  @override
  Future<Either<Failure, TekananDarahEntity>> updateTekananDarah({
    required String tekananDarahId,
    required double sistolik,
    required double diastolik,
    required DateTime pemeriksaanAt,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      final updatedData = await remoteDataSource.updateTekananDarah(
        tekananDarahId: tekananDarahId,
        sistolik: sistolik,
        diastolik: diastolik,
        pemeriksaanAt: pemeriksaanAt,
      );
      return right(updatedData);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // Hapus data pemeriksaan tekanan darah berdasarkan ID
  @override
  Future<Either<Failure, void>> deleteTekananDarah(
      String tekananDarahId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      await remoteDataSource.deleteTekananDarah(tekananDarahId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}

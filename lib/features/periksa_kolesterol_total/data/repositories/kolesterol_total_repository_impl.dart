import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/constants/constants.dart';
import 'package:posbinduptm/core/error/exceptions.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/network/connection_checker.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/data/datasources/kolesterol_total_remote_data_source.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/data/models/kolesterol_total_model.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/entities/kolesterol_total_entity.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/repositories/kolesterol_total_repository.dart';
import 'package:uuid/uuid.dart';

class KolesterolTotalRepositoryImpl implements KolesterolTotalRepository {
  final KolesterolTotalRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  KolesterolTotalRepositoryImpl(
    this.remoteDataSource,
    this.connectionChecker,
  );

  // Ambil semua data pemeriksaan kolesterol total berdasarkan profileId
  @override
  Future<Either<Failure, List<KolesterolTotalEntity>>> getAllKolesterolTotal({
    required String profileId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      final kolesterolTotalList =
          await remoteDataSource.getAllKolesterolTotal(profileId: profileId);
      return right(kolesterolTotalList);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // Upload data pemeriksaan kolesterol total
  @override
  Future<Either<Failure, KolesterolTotalEntity>> uploadKolesterolTotal({
    required double kolesterolTotal,
    required String profileId,
    required DateTime pemeriksaanAt,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      KolesterolTotalModel kolesterolTotalModel = KolesterolTotalModel(
        kolesterolTotalId: const Uuid().v1(),
        profileId: profileId,
        kolesterolTotal: kolesterolTotal,
        updatedAt: DateTime.now(),
        pemeriksaanAt: pemeriksaanAt,
      );
      final uploadedKolesterolTotal =
          await remoteDataSource.uploadKolesterolTotal(kolesterolTotalModel);
      return right(uploadedKolesterolTotal);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // Update data pemeriksaan kolesterol total berdasarkan ID (mengembalikan entity terbaru)
  @override
  Future<Either<Failure, KolesterolTotalEntity>> updateKolesterolTotal({
    required String kolesterolTotalId,
    required double kolesterolTotal,
    required DateTime pemeriksaanAt,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      final updatedData = await remoteDataSource.updateKolesterolTotal(
        kolesterolTotalId: kolesterolTotalId,
        kolesterolTotal: kolesterolTotal,
        pemeriksaanAt: pemeriksaanAt,
      );
      return right(updatedData);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // Hapus data pemeriksaan kolesterol total berdasarkan ID
  @override
  Future<Either<Failure, void>> deleteKolesterolTotal(
      String kolesterolTotalId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      await remoteDataSource.deleteKolesterolTotal(kolesterolTotalId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}

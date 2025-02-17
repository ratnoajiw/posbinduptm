import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/gula_darah_entity.dart';

abstract interface class GulaDarahRepository {
  // Ambil semua data pemeriksaan gula darah berdasarkan profileId
  Future<Either<Failure, List<GulaDarahEntity>>> getAllGulaDarah({
    required String profileId,
  });

  // Ambil data pemeriksaan gula darah terbaru
  Future<Either<Failure, GulaDarahEntity?>> getLatestGulaDarah({
    required String profileId,
  });

  // Tambah data pemeriksaan gula darah baru
  Future<Either<Failure, GulaDarahEntity>> uploadGulaDarah({
    required String profileId,
    required double gulaDarahSewaktu,
    required DateTime pemeriksaanAt,
  });

  // Update data pemeriksaan gula darah berdasarkan ID
  Future<Either<Failure, GulaDarahEntity>> updateGulaDarah({
    required String gulaDarahId,
    required double gulaDarahSewaktu,
    required DateTime pemeriksaanAt,
  });

  // Hapus data pemeriksaan gula darah berdasarkan ID
  Future<Either<Failure, void>> deleteGulaDarah(
    String gulaDarahId,
  );
}

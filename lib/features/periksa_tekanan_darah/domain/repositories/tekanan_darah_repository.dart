import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/entities/tekanan_darah_entity.dart';

abstract interface class TekananDarahRepository {
  // Ambil semua data pemeriksaan tekanan darah berdasarkan profileId
  Future<Either<Failure, List<TekananDarahEntity>>> getAllTekananDarah({
    required String profileId,
  });

  // Ambil data pemeriksaan tekanan darah terbaru
  Future<Either<Failure, TekananDarahEntity?>> getLatestTekananDarah({
    required String profileId,
  });

  // Tambah data pemeriksaan tekanan darah baru
  Future<Either<Failure, TekananDarahEntity>> uploadTekananDarah({
    required String profileId,
    required double sistolik,
    required double diastolik,
    required DateTime pemeriksaanAt,
  });

  // Update data pemeriksaan tekanan darah berdasarkan ID
  Future<Either<Failure, TekananDarahEntity>> updateTekananDarah({
    required String tekananDarahId,
    required double sistolik,
    required double diastolik,
    required DateTime pemeriksaanAt,
  });

  // Hapus data pemeriksaan tekanan darah berdasarkan ID
  Future<Either<Failure, void>> deleteTekananDarah(
    String tekananDarahId,
  );
}

import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/entities/kolesterol_total_entity.dart';

abstract interface class KolesterolTotalRepository {
  // Ambil semua data pemeriksaan kolesterol total berdasarkan profileId
  Future<Either<Failure, List<KolesterolTotalEntity>>> getAllKolesterolTotal({
    required String profileId,
  });

  // Tambah data pemeriksaan kolesterol total baru
  Future<Either<Failure, KolesterolTotalEntity>> uploadKolesterolTotal({
    required String profileId,
    required double kolesterolTotal,
    required DateTime pemeriksaanAt,
  });

  // Update data pemeriksaan kolesterol total berdasarkan ID
  Future<Either<Failure, KolesterolTotalEntity>> updateKolesterolTotal({
    required String kolesterolTotalId,
    required double kolesterolTotal,
    required DateTime pemeriksaanAt,
  });

  // Hapus data pemeriksaan kolesterol total berdasarkan ID
  Future<Either<Failure, void>> deleteKolesterolTotal(
    String kolesterolTotalId,
  );
}

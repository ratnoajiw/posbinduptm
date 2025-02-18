import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/features/pasien/domain/entities/pasien_entity.dart';

abstract interface class PasienRepository {
  // Dapatkan data pasien berdasarkan profileId
  Future<Either<Failure, PasienEntity?>> getPasienByProfileId({
    required String profileId,
  });

  // Buat data pasien baru
  Future<Either<Failure, PasienEntity>> createPasien({
    required String profileId,
    String? nik,
    String? jenisKelamin,
    DateTime? tanggalLahir,
    String? alamat,
    String? nomorHp,
  });

  // Update data pasien
  Future<Either<Failure, PasienEntity>> updatePasien({
    required String pasienId,
    String? nik,
    String? jenisKelamin,
    DateTime? tanggalLahir,
    String? alamat,
    String? nomorHp,
    required String profileName, // Tambahkan profileName
  });
}

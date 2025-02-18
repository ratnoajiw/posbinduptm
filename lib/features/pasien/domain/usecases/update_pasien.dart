import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/pasien/domain/entities/pasien_entity.dart';
import 'package:posbinduptm/features/pasien/domain/repositories/pasien_repository.dart';

class UpdatePasien implements UseCase<PasienEntity, UpdatePasienParams> {
  final PasienRepository repository;

  UpdatePasien(this.repository);

  @override
  Future<Either<Failure, PasienEntity>> call(UpdatePasienParams params) async {
    return await repository.updatePasien(
      pasienId: params.pasienId,
      nik: params.nik,
      jenisKelamin: params.jenisKelamin,
      tanggalLahir: params.tanggalLahir,
      alamat: params.alamat,
      nomorHp: params.nomorHp,
      profileName: params.profilName, // Tambahkan profileName
    );
  }
}

class UpdatePasienParams {
  final String pasienId;
  final String? nik;
  final String? jenisKelamin;
  final DateTime? tanggalLahir;
  final String? alamat;
  final String? nomorHp;
  final String profilName;

  UpdatePasienParams({
    required this.pasienId,
    this.nik,
    this.jenisKelamin,
    this.tanggalLahir,
    this.alamat,
    this.nomorHp,
    required this.profilName,
  });
}

import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/pasien/domain/entities/pasien_entity.dart';
import 'package:posbinduptm/features/pasien/domain/repositories/pasien_repository.dart';

class CreatePasien implements UseCase<PasienEntity, CreatePasienParams> {
  final PasienRepository repository;

  CreatePasien(this.repository);

  @override
  Future<Either<Failure, PasienEntity>> call(CreatePasienParams params) async {
    return await repository.createPasien(
      profileId: params.profileId,
      nik: params.nik,
      jenisKelamin: params.jenisKelamin,
      tanggalLahir: params.tanggalLahir,
      alamat: params.alamat,
      nomorHp: params.nomorHp,
    );
  }
}

class CreatePasienParams {
  final String profileId;
  final String? nik;
  final String? jenisKelamin;
  final DateTime? tanggalLahir;
  final String? alamat;
  final String? nomorHp;

  CreatePasienParams({
    required this.profileId,
    this.nik,
    this.jenisKelamin,
    this.tanggalLahir,
    this.alamat,
    this.nomorHp,
  });
}

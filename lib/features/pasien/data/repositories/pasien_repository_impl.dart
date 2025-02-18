import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/constants/constants.dart';
import 'package:posbinduptm/core/error/exceptions.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/network/connection_checker.dart';
import 'package:posbinduptm/features/pasien/data/datasources/pasien_remote_data_source.dart';
import 'package:posbinduptm/features/pasien/data/models/pasien_model.dart';
import 'package:posbinduptm/features/pasien/domain/entities/pasien_entity.dart';
import 'package:posbinduptm/features/pasien/domain/repositories/pasien_repository.dart';

class PasienRepositoryImpl implements PasienRepository {
  final PasienRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  final AppUserCubit _appUserCubit;

  PasienRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
    required AppUserCubit appUserCubit,
  }) : _appUserCubit = appUserCubit;

  @override
  Future<Either<Failure, PasienEntity?>> getPasienByProfileId({
    required String profileId,
  }) async {
    if (!await connectionChecker.isConnected) {
      return left(Failure(Constant.noConnectionErrorMessage));
    }
    try {
      final result = await remoteDataSource.getPasienByProfileId(
        profileId: profileId,
      );
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, PasienEntity>> createPasien({
    required String profileId,
    String? nik,
    String? jenisKelamin,
    DateTime? tanggalLahir,
    String? alamat,
    String? nomorHp,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      if (_appUserCubit.state is AppUserLoggedIn) {
        final profileId = (_appUserCubit.state as AppUserLoggedIn).user.id;
        final pasienModel = PasienModel(
          pasienId: profileId,
          profileId: profileId,
          nik: nik,
          jenisKelamin: jenisKelamin,
          tanggalLahir: tanggalLahir,
          alamat: alamat,
          nomorHp: nomorHp,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await remoteDataSource.createPasien(pasienModel);
        return Right(pasienModel);
      } else {
        return Left(Failure("Gagal mendapatkan data user"));
      }
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, PasienEntity>> updatePasien({
    required String pasienId,
    String? nik,
    String? jenisKelamin,
    DateTime? tanggalLahir,
    String? alamat,
    String? nomorHp,
    required String profileName, // Tambahkan profileName
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }

      // Ambil data pasien dari database menggunakan pasienId
      final result =
          await remoteDataSource.getPasienByPasienId(pasienId: pasienId);

      // Pastikan datanya ada
      if (result == null) {
        return left(Failure("Data Pasien tidak ditemukan"));
      }

      final pasienModel = PasienModel(
        pasienId: pasienId,
        profileId: result.profileId,
        nik: nik ?? result.nik,
        jenisKelamin: jenisKelamin ?? result.jenisKelamin,
        tanggalLahir: tanggalLahir ?? result.tanggalLahir,
        alamat: alamat ?? result.alamat,
        nomorHp: nomorHp ?? result.nomorHp,
        createdAt: result.createdAt,
        updatedAt: DateTime.now(),
      );

      await remoteDataSource.updatePasien(pasienModel);
      // Update nama profil
      await remoteDataSource.updateProfileName(
        profileId: result.profileId,
        profileName: profileName,
      );

      // Dapatkan data pengguna terbaru dari database
      final updatedUser = await remoteDataSource.getUserById(result.profileId);

      // Pastikan data pengguna ditemukan
      if (updatedUser == null) {
        return left(Failure("Gagal mendapatkan data user terbaru"));
      }

      // Update AppUserCubit
      _appUserCubit.updateUser(updatedUser);

      return right(pasienModel);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}

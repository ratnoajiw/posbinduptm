import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/common/entities/app_user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, AppUser>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> logInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> currentUser();

  Future<Either<Failure, void>> logOut();
}

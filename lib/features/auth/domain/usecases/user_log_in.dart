import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/core/common/entities/app_user.dart';
import 'package:posbinduptm/features/auth/domain/repositories/auth_repository.dart';

class UserLogIn implements UseCase<AppUser, UserLogInParams> {
  final AuthRepository authRepository;
  const UserLogIn(this.authRepository);

  @override
  Future<Either<Failure, AppUser>> call(UserLogInParams params) async {
    return await authRepository.logInWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLogInParams {
  final String email;
  final String password;

  UserLogInParams({
    required this.email,
    required this.password,
  });
}

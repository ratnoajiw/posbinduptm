import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/auth/domain/repositories/auth_repository.dart';

class UserLogOut implements UseCase<void, NoParams> {
  // Note: void and NoParams
  final AuthRepository authRepository;
  const UserLogOut(this.authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.logOut();
  }
}

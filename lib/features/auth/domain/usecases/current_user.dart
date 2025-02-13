import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/core/common/entities/app_user.dart';
import 'package:posbinduptm/features/auth/domain/repositories/auth_repository.dart';

class CurrentUser implements UseCase<AppUser, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, AppUser>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}

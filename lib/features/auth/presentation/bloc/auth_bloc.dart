import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/core/common/entities/app_user.dart';
import 'package:posbinduptm/features/auth/domain/usecases/current_user.dart';
import 'package:posbinduptm/features/auth/domain/usecases/user_log_in.dart';
import 'package:posbinduptm/features/auth/domain/usecases/user_log_out.dart';
import 'package:posbinduptm/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogIn _userLogIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final UserLogOut _userLogOut;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogIn userLogIn,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required UserLogOut userLogOut,
  })  : _userSignUp = userSignUp,
        _userLogIn = userLogIn,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        _userLogOut = userLogOut,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogIn>(_onAuthLogIn);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthLogOut>(_onAuthLogOut);
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (l) {
        emit(AuthUnauthenticated());
      },
      (r) {
        _emitAuthSuccess(r, emit);
      },
    );
  }

  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogIn(
    AuthLogIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userLogIn(
      UserLogInParams(
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _emitAuthSuccess(
    AppUser user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }

  void _onAuthLogOut(
    AuthLogOut event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _userLogOut(NoParams());

    result.fold(
      (failure) {
        emit(AuthFailure(failure.message));
      },
      (_) {
        _appUserCubit.logout();
        emit(AuthUnauthenticated());
      },
    );
  }
}

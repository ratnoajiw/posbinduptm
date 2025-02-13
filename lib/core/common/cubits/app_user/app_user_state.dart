part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final AppUser user;
  AppUserLoggedIn(this.user);
}

final class AppUserLoading extends AppUserState {}

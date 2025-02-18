import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/core/common/entities/app_user.dart';
import 'package:posbinduptm/core/common/models/app_user_model.dart'; // Import AppUserModel

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  // State awal cubit adalah AppUserInitial (user belum login)
  AppUserCubit() : super(AppUserInitial());

  // Fungsi untuk mengupdate data user
  void updateUser(AppUser? user) {
    // Jika user null (tidak ada user), emit state AppUserInitial
    if (user == null) {
      emit(AppUserInitial());
    } else {
      // Jika user ada, emit state AppUserLoggedIn dengan data user
      final userModel =
          AppUserModel.fromAppUser(user); // Konversi ke AppUserModel
      emit(AppUserLoggedIn(userModel)); // Emit AppUserModel
    }
  }

  // Fungsi untuk logout user
  void logout() {
    emit(AppUserInitial());
  }

  void onLoginSuccess(BuildContext context, AppUser user) {
    context.read<AppUserCubit>().updateUser(user);
  }
}

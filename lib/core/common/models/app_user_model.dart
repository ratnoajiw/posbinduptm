// core/common/models/app_user_model.dart
import 'package:posbinduptm/core/common/entities/app_user.dart';

class AppUserModel {
  final String id;
  final String email;
  final String? name;

  AppUserModel({
    required this.id,
    required this.email,
    this.name,
  });

  factory AppUserModel.fromAppUser(AppUser user) {
    return AppUserModel(
      id: user.id,
      email: user.email,
      name: user.name,
    );
  }
}

part of 'antropometri_bloc.dart';

@immutable
sealed class AntropometriState {}

final class AntropometriInitial extends AntropometriState {}

final class AntropometriLoading extends AntropometriState {}

final class AntropometriFailure extends AntropometriState {
  final String error;
  AntropometriFailure(this.error);
}

final class AntropometriUploadSuccess extends AntropometriState {}

final class AntropometrisDisplaySuccess extends AntropometriState {
  final List<AntropometriEntity> antropometriList;
  AntropometrisDisplaySuccess(this.antropometriList);
}

final class AntropometriDeleteSuccess extends AntropometriState {}

final class AntropometriUpdateSuccess extends AntropometriState {}

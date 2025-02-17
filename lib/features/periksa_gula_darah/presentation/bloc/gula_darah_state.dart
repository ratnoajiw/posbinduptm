part of 'gula_darah_bloc.dart';

@immutable
sealed class GulaDarahState extends Equatable {
  const GulaDarahState();

  @override
  List<Object> get props => [];
}

final class GulaDarahInitial extends GulaDarahState {}

final class GulaDarahLoading extends GulaDarahState {}

final class GulaDarahFailure extends GulaDarahState {
  final String error;
  const GulaDarahFailure(this.error);
}

final class GulaDarahUploadSuccess extends GulaDarahState {}

final class GulaDarahDisplaySuccess extends GulaDarahState {
  final List<GulaDarahEntity> gulaDarahList;
  const GulaDarahDisplaySuccess(this.gulaDarahList);
}

final class GulaDarahDeleteSuccess extends GulaDarahState {}

final class GulaDarahUpdateSuccess extends GulaDarahState {}

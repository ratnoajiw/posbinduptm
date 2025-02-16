part of 'periksa_gula_darah_bloc.dart';

@immutable
sealed class PeriksaGulaDarahState extends Equatable {
  const PeriksaGulaDarahState();

  @override
  List<Object> get props => [];
}

final class PeriksaGulaDarahInitial extends PeriksaGulaDarahState {}

final class PeriksaGulaDarahLoading extends PeriksaGulaDarahState {}

final class PeriksaGulaDarahFailure extends PeriksaGulaDarahState {
  final String error;
  const PeriksaGulaDarahFailure(this.error);
}

final class PeriksaGulaDarahUploadSuccess extends PeriksaGulaDarahState {}

final class PeriksaGulaDarahDisplaySuccess extends PeriksaGulaDarahState {
  final List<PeriksaGulaDarahEntity> periksaGulaDarahList;
  const PeriksaGulaDarahDisplaySuccess(this.periksaGulaDarahList);
}

final class PeriksaGulaDarahDeleteSuccess extends PeriksaGulaDarahState {}

final class PeriksaGulaDarahUpdateSuccess extends PeriksaGulaDarahState {}

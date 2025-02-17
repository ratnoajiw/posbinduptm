part of 'tekanan_darah_bloc.dart';

@immutable
sealed class TekananDarahState extends Equatable {
  const TekananDarahState();

  @override
  List<Object> get props => [];
}

final class TekananDarahInitial extends TekananDarahState {}

final class TekananDarahLoading extends TekananDarahState {}

final class TekananDarahFailure extends TekananDarahState {
  final String error;
  const TekananDarahFailure(this.error);
}

final class TekananDarahUploadSuccess extends TekananDarahState {}

final class TekananDarahDisplaySuccess extends TekananDarahState {
  final List<TekananDarahEntity> tekananDarahList;
  const TekananDarahDisplaySuccess(this.tekananDarahList);
}

final class TekananDarahDeleteSuccess extends TekananDarahState {}

final class TekananDarahUpdateSuccess extends TekananDarahState {}

final class TekananDarahLatestSuccess extends TekananDarahState {
  final TekananDarahEntity latestTekananDarah;
  const TekananDarahLatestSuccess(this.latestTekananDarah);
}

final class TekananDarahLatestEmpty extends TekananDarahState {
  const TekananDarahLatestEmpty();
}

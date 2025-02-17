part of 'kolesterol_total_bloc.dart';

@immutable
sealed class KolesterolTotalState extends Equatable {
  const KolesterolTotalState();

  @override
  List<Object> get props => [];
}

final class KolesterolTotalInitial extends KolesterolTotalState {}

final class KolesterolTotalLoading extends KolesterolTotalState {}

final class KolesterolTotalFailure extends KolesterolTotalState {
  final String error;
  const KolesterolTotalFailure(this.error);
}

final class KolesterolTotalUploadSuccess extends KolesterolTotalState {}

final class KolesterolTotalDisplaySuccess extends KolesterolTotalState {
  final List<KolesterolTotalEntity> kolesterolTotalList;
  const KolesterolTotalDisplaySuccess(this.kolesterolTotalList);
}

final class KolesterolTotalDeleteSuccess extends KolesterolTotalState {}

final class KolesterolTotalUpdateSuccess extends KolesterolTotalState {}

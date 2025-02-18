part of 'pasien_bloc.dart';

@immutable
sealed class PasienState extends Equatable {
  const PasienState();

  @override
  List<Object> get props => [];
}

final class PasienInitial extends PasienState {}

final class PasienLoading extends PasienState {}

final class PasienLoaded extends PasienState {
  final PasienEntity? pasien;

  const PasienLoaded(this.pasien);
}

final class PasienLoadedForUpdate extends PasienState {
  final PasienEntity pasien;

  const PasienLoadedForUpdate(this.pasien);
}

final class PasienCreated extends PasienState {}

final class PasienFailure extends PasienState {
  final String error;

  const PasienFailure(this.error);
}

part of 'pasien_bloc.dart';

sealed class PasienEvent extends Equatable {
  const PasienEvent();

  @override
  List<Object> get props => [];
}

class GetPasienEvent extends PasienEvent {
  final String profileId;

  const GetPasienEvent({required this.profileId});
}

class CreatePasienEvent extends PasienEvent {
  final String profileId;
  final String? nik;
  final String? jenisKelamin;
  final DateTime? tanggalLahir;
  final String? alamat;
  final String? nomorHp;

  const CreatePasienEvent({
    required this.profileId,
    this.nik,
    this.jenisKelamin,
    this.tanggalLahir,
    this.alamat,
    this.nomorHp,
  });
}

class UpdatePasienEvent extends PasienEvent {
  final String pasienId;
  final String? nik;
  final String? jenisKelamin;
  final DateTime? tanggalLahir;
  final String? alamat;
  final String? nomorHp;
  final String profileName;

  const UpdatePasienEvent(
      {required this.pasienId,
      this.nik,
      this.jenisKelamin,
      this.tanggalLahir,
      this.alamat,
      this.nomorHp,
      required this.profileName});
}

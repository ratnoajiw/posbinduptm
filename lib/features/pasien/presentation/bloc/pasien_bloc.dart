import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/features/pasien/domain/entities/pasien_entity.dart';
import 'package:posbinduptm/features/pasien/domain/usecases/create_pasien.dart';
import 'package:posbinduptm/features/pasien/domain/usecases/get_pasien_by_profile_id.dart';
import 'package:posbinduptm/features/pasien/domain/usecases/update_pasien.dart';

part 'pasien_event.dart';
part 'pasien_state.dart';

class PasienBloc extends Bloc<PasienEvent, PasienState> {
  final GetPasienByProfileId _getPasienByProfileId;
  final CreatePasien _createPasien;
  final UpdatePasien _updatePasien;

  PasienBloc({
    required GetPasienByProfileId getPasienByProfileId,
    required CreatePasien createPasien,
    required UpdatePasien updatePasien,
  })  : _getPasienByProfileId = getPasienByProfileId,
        _createPasien = createPasien,
        _updatePasien = updatePasien,
        super(PasienInitial()) {
    on<GetPasienEvent>(_onGetPasien);
    on<CreatePasienEvent>(_onCreatePasien);
    on<UpdatePasienEvent>(_onUpdatePasien);
  }

  // Dapatkan data pasien
  void _onGetPasien(GetPasienEvent event, Emitter<PasienState> emit) async {
    emit(PasienLoading());
    final result = await _getPasienByProfileId(
        GetPasienByProfileIdParams(profileId: event.profileId));
    result.fold(
      (failure) => emit(PasienFailure(failure.message)),
      (pasien) => emit(PasienLoaded(pasien)),
    );
  }

  // Buat data pasien
  void _onCreatePasien(
      CreatePasienEvent event, Emitter<PasienState> emit) async {
    // Tambahkan log
    emit(PasienLoading());
    final result = await _createPasien(CreatePasienParams(
      profileId: event.profileId,
      nik: event.nik,
      jenisKelamin: event.jenisKelamin,
      tanggalLahir: event.tanggalLahir,
      alamat: event.alamat,
      nomorHp: event.nomorHp,
    ));
    result.fold(
      (failure) {
        // Tambahkan log
        emit(PasienFailure(failure.message));
      },
      (pasien) {
        // Tambahkan log
        emit(PasienCreated());
      },
    );
  }

  void _onUpdatePasien(
      UpdatePasienEvent event, Emitter<PasienState> emit) async {
    debugPrint('Menerima UpdatePasienEvent dengan pasienId: ${event.pasienId}');
    emit(PasienLoading());
    final result = await _updatePasien(UpdatePasienParams(
        pasienId: event.pasienId,
        nik: event.nik,
        jenisKelamin: event.jenisKelamin,
        tanggalLahir: event.tanggalLahir,
        alamat: event.alamat,
        nomorHp: event.nomorHp,
        profilName: event.profileName));
    result.fold(
      (failure) => emit(PasienFailure(failure.message)),
      (pasien) => emit(PasienLoaded(pasien)),
    );
  }
}

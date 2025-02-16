import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/periksa_gula_darah_entity.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/usecases/delete_periksa_gula_darah.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/usecases/get_all_periksa_gula_darah.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/usecases/update_periksa_gula_darah.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/usecases/upload_periksa_gula_darah.dart';

part 'periksa_gula_darah_event.dart';
part 'periksa_gula_darah_state.dart';

class PeriksaGulaDarahBloc
    extends Bloc<PeriksaGulaDarahEvent, PeriksaGulaDarahState> {
  final UploadPeriksaGulaDarah _uploadPeriksaGulaDarah;
  final GetAllPeriksaGulaDarah _getAllPeriksaGulaDarah;
  final DeletePeriksaGulaDarah _deletePeriksaGulaDarah;
  final UpdatePeriksaGulaDarah _updatePeriksaGulaDarah;

  PeriksaGulaDarahBloc({
    required UploadPeriksaGulaDarah uploadPeriksaGulaDarah,
    required GetAllPeriksaGulaDarah getAllPeriksaGulaDarah,
    required DeletePeriksaGulaDarah deletePeriksaGulaDarah,
    required UpdatePeriksaGulaDarah updatePeriksaGulaDarah,
  })  : _uploadPeriksaGulaDarah = uploadPeriksaGulaDarah,
        _getAllPeriksaGulaDarah = getAllPeriksaGulaDarah,
        _deletePeriksaGulaDarah = deletePeriksaGulaDarah,
        _updatePeriksaGulaDarah = updatePeriksaGulaDarah,
        super(PeriksaGulaDarahInitial()) {
    on<PeriksaGulaDarahUpload>(_onUploadPeriksaGulaDarah);
    on<PeriksaGulaDarahUpdate>(_onUpdatePeriksaGulaDarah);
    on<PeriksaGulaDarahList>(_onGetAllPeriksaGulaDarah);
    on<PeriksaGulaDarahDelete>(_onDeletePeriksaGulaDarah);
    on<PeriksaGulaDarahGet>(_onGetPeriksaGulaDarah);
  }

  // Ambil semua data pemeriksaan gula darah berdasarkan profileId
  void _onGetAllPeriksaGulaDarah(
      PeriksaGulaDarahList event, Emitter<PeriksaGulaDarahState> emit) async {
    emit(PeriksaGulaDarahLoading());
    final res = await _getAllPeriksaGulaDarah(
        GetAllPeriksaGulaDarahParams(profileId: event.profileId));
    res.fold(
      (failure) => emit(PeriksaGulaDarahFailure(failure.message)),
      (data) => emit(PeriksaGulaDarahDisplaySuccess(data)),
    );
  }

  // Upload data pemeriksaan gula darah baru
  void _onUploadPeriksaGulaDarah(
      PeriksaGulaDarahUpload event, Emitter<PeriksaGulaDarahState> emit) async {
    emit(PeriksaGulaDarahLoading());
    final res = await _uploadPeriksaGulaDarah(UploadPeriksaGulaDarahParams(
      profileId: event.profileId,
      gulaDarahSewaktu: event.gulaDarahSewaktu,
      pemeriksaanAt: event.pemeriksaanAt,
    ));
    res.fold(
      (failure) => emit(PeriksaGulaDarahFailure(failure.message)),
      (_) => emit(PeriksaGulaDarahUploadSuccess()),
    );
  }

  // Update data pemeriksaan gula darah
  void _onUpdatePeriksaGulaDarah(
      PeriksaGulaDarahUpdate event, Emitter<PeriksaGulaDarahState> emit) async {
    emit(PeriksaGulaDarahLoading());
    final res = await _updatePeriksaGulaDarah(UpdatePeriksaGulaDarahParams(
      id: event.id,
      gulaDarahSewaktu: event.gulaDarahSewaktu,
      pemeriksaanAt: event.pemeriksaanAt,
    ));
    res.fold(
      (failure) => emit(PeriksaGulaDarahFailure(failure.message)),
      (data) => emit(PeriksaGulaDarahUpdateSuccess()),
    );
  }

  // Hapus data pemeriksaan gula darah berdasarkan ID
  void _onDeletePeriksaGulaDarah(
      PeriksaGulaDarahDelete event, Emitter<PeriksaGulaDarahState> emit) async {
    emit(PeriksaGulaDarahLoading());
    final res = await _deletePeriksaGulaDarah(
        DeletePeriksaGulaDarahParams(id: event.gulaDarahSewaktuId));
    res.fold(
      (failure) => emit(PeriksaGulaDarahFailure(failure.message)),
      (_) => emit(PeriksaGulaDarahDeleteSuccess()),
    );
  }

  // Ambil satu data pemeriksaan gula darah berdasarkan ID
  void _onGetPeriksaGulaDarah(
      PeriksaGulaDarahGet event, Emitter<PeriksaGulaDarahState> emit) async {
    emit(PeriksaGulaDarahLoading());
    final res = await _getAllPeriksaGulaDarah(
        GetAllPeriksaGulaDarahParams(profileId: event.gulaDarahSewaktuId));
    res.fold(
      (failure) => emit(PeriksaGulaDarahFailure(failure.message)),
      (data) {
        if (data.isNotEmpty) {
          emit(PeriksaGulaDarahDisplaySuccess([data.first]));
        } else {
          emit(const PeriksaGulaDarahFailure("Data tidak ditemukan"));
        }
      },
    );
  }
}

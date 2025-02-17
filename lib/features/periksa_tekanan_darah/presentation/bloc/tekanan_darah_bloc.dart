import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/entities/tekanan_darah_entity.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/usecases/delete_tekanan_darah.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/usecases/get_all_tekanan_darah.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/usecases/update_tekanan_darah.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/usecases/upload_tekanan_darah.dart';

part 'tekanan_darah_event.dart';
part 'tekanan_darah_state.dart';

class TekananDarahBloc extends Bloc<TekananDarahEvent, TekananDarahState> {
  final UploadTekananDarah _uploadTekananDarah;
  final GetAllTekananDarah _getAllTekananDarah;
  final DeleteTekananDarah _deleteTekananDarah;
  final UpdateTekananDarah _updateTekananDarah;

  TekananDarahBloc({
    required UploadTekananDarah uploadTekananDarah,
    required GetAllTekananDarah getAllTekananDarah,
    required DeleteTekananDarah deleteTekananDarah,
    required UpdateTekananDarah updateTekananDarah,
  })  : _uploadTekananDarah = uploadTekananDarah,
        _getAllTekananDarah = getAllTekananDarah,
        _deleteTekananDarah = deleteTekananDarah,
        _updateTekananDarah = updateTekananDarah,
        super(TekananDarahInitial()) {
    on<TekananDarahUpload>(_onUploadTekananDarah);
    on<TekananDarahUpdate>(_onUpdateTekananDarah);
    on<TekananDarahList>(_onGetAllTekananDarah);
    on<TekananDarahDelete>(_onDeleteTekananDarah);
    on<TekananDarahGet>(_onGetTekananDarah);
  }

  // Ambil semua data pemeriksaan tekanan darah berdasarkan profileId
  void _onGetAllTekananDarah(
      TekananDarahList event, Emitter<TekananDarahState> emit) async {
    emit(TekananDarahLoading());
    final result = await _getAllTekananDarah(
        GetAllTekananDarahParams(profileId: event.profileId));
    result.fold(
      (failure) => emit(TekananDarahFailure(failure.message)),
      (data) => emit(TekananDarahDisplaySuccess(data)),
    );
  }

  // Upload data pemeriksaan tekanan darah baru
  void _onUploadTekananDarah(
      TekananDarahUpload event, Emitter<TekananDarahState> emit) async {
    emit(TekananDarahLoading());
    final result = await _uploadTekananDarah(UploadTekananDarahParams(
      profileId: event.profileId,
      sistolik: event.sistolik,
      diastolik: event.diastolik,
      pemeriksaanAt: event.pemeriksaanAt,
    ));
    result.fold(
      (failure) => emit(TekananDarahFailure(failure.message)),
      (_) => emit(TekananDarahUploadSuccess()),
    );
  }

  // Update data pemeriksaan tekanan darah
  void _onUpdateTekananDarah(
      TekananDarahUpdate event, Emitter<TekananDarahState> emit) async {
    emit(TekananDarahLoading());
    final result = await _updateTekananDarah(UpdateTekananDarahParams(
      tekananDarahId: event.tekananDarahId,
      sistolik: event.sistolik,
      diastolik: event.diastolik,
      pemeriksaanAt: event.pemeriksaanAt,
    ));
    result.fold(
      (failure) => emit(TekananDarahFailure(failure.message)),
      (data) => emit(TekananDarahUpdateSuccess()),
    );
  }

  // Hapus data pemeriksaan tekanan darah berdasarkan ID
  void _onDeleteTekananDarah(
      TekananDarahDelete event, Emitter<TekananDarahState> emit) async {
    emit(TekananDarahLoading());
    final result = await _deleteTekananDarah(
        DeleteTekananDarahParams(tekananDarahId: event.tekananDarahId));
    result.fold(
      (failure) => emit(TekananDarahFailure(failure.message)),
      (_) => emit(TekananDarahDeleteSuccess()),
    );
  }

  // Ambil satu data pemeriksaan tekanan darah berdasarkan ID
  void _onGetTekananDarah(
      TekananDarahGet event, Emitter<TekananDarahState> emit) async {
    emit(TekananDarahLoading());
    final result = await _getAllTekananDarah(
        GetAllTekananDarahParams(profileId: event.tekananDarahId));
    result.fold(
      (failure) => emit(TekananDarahFailure(failure.message)),
      (data) {
        if (data.isNotEmpty) {
          emit(TekananDarahDisplaySuccess([data.first]));
        } else {
          emit(const TekananDarahFailure("Data tidak ditemukan"));
        }
      },
    );
  }
}

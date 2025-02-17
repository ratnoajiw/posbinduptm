import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/gula_darah_entity.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/usecases/delete_gula_darah.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/usecases/get_all_gula_darah.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/usecases/update_gula_darah.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/usecases/upload_gula_darah.dart';

part 'gula_darah_event.dart';
part 'gula_darah_state.dart';

class GulaDarahBloc extends Bloc<GulaDarahEvent, GulaDarahState> {
  final UploadGulaDarah _uploadGulaDarah;
  final GetAllGulaDarah _getAllGulaDarah;
  final DeleteGulaDarah _deleteGulaDarah;
  final UpdateGulaDarah _updateGulaDarah;

  GulaDarahBloc({
    required UploadGulaDarah uploadGulaDarah,
    required GetAllGulaDarah getAllGulaDarah,
    required DeleteGulaDarah deleteGulaDarah,
    required UpdateGulaDarah updateGulaDarah,
  })  : _uploadGulaDarah = uploadGulaDarah,
        _getAllGulaDarah = getAllGulaDarah,
        _deleteGulaDarah = deleteGulaDarah,
        _updateGulaDarah = updateGulaDarah,
        super(GulaDarahInitial()) {
    on<GulaDarahUpload>(_onUploadGulaDarah);
    on<GulaDarahUpdate>(_onUpdateGulaDarah);
    on<GulaDarahList>(_onGetAllGulaDarah);
    on<GulaDarahDelete>(_onDeleteGulaDarah);
    on<GulaDarahGet>(_onGetGulaDarah);
  }

  // Ambil semua data pemeriksaan gula darah berdasarkan profileId
  void _onGetAllGulaDarah(
      GulaDarahList event, Emitter<GulaDarahState> emit) async {
    emit(GulaDarahLoading());
    final res = await _getAllGulaDarah(
        GetAllGulaDarahParams(profileId: event.profileId));
    res.fold(
      (failure) => emit(GulaDarahFailure(failure.message)),
      (data) => emit(GulaDarahDisplaySuccess(data)),
    );
  }

  // Upload data pemeriksaan gula darah baru
  void _onUploadGulaDarah(
      GulaDarahUpload event, Emitter<GulaDarahState> emit) async {
    emit(GulaDarahLoading());
    final res = await _uploadGulaDarah(UploadGulaDarahParams(
      profileId: event.profileId,
      gulaDarahSewaktu: event.gulaDarahSewaktu,
      pemeriksaanAt: event.pemeriksaanAt,
    ));
    res.fold(
      (failure) => emit(GulaDarahFailure(failure.message)),
      (_) => emit(GulaDarahUploadSuccess()),
    );
  }

  // Update data pemeriksaan gula darah
  void _onUpdateGulaDarah(
      GulaDarahUpdate event, Emitter<GulaDarahState> emit) async {
    emit(GulaDarahLoading());
    final res = await _updateGulaDarah(UpdateGulaDarahParams(
      gulaDarahId: event.gulaDarahId,
      gulaDarahSewaktu: event.gulaDarahSewaktu,
      pemeriksaanAt: event.pemeriksaanAt,
    ));
    res.fold(
      (failure) => emit(GulaDarahFailure(failure.message)),
      (data) => emit(GulaDarahUpdateSuccess()),
    );
  }

  // Hapus data pemeriksaan gula darah berdasarkan ID
  void _onDeleteGulaDarah(
      GulaDarahDelete event, Emitter<GulaDarahState> emit) async {
    emit(GulaDarahLoading());
    final res = await _deleteGulaDarah(
        DeleteGulaDarahParams(id: event.gulaDarahSewaktuId));
    res.fold(
      (failure) => emit(GulaDarahFailure(failure.message)),
      (_) => emit(GulaDarahDeleteSuccess()),
    );
  }

  // Ambil satu data pemeriksaan gula darah berdasarkan ID
  void _onGetGulaDarah(GulaDarahGet event, Emitter<GulaDarahState> emit) async {
    emit(GulaDarahLoading());
    final res = await _getAllGulaDarah(
        GetAllGulaDarahParams(profileId: event.gulaDarahSewaktuId));
    res.fold(
      (failure) => emit(GulaDarahFailure(failure.message)),
      (data) {
        if (data.isNotEmpty) {
          emit(GulaDarahDisplaySuccess([data.first]));
        } else {
          emit(const GulaDarahFailure("Data tidak ditemukan"));
        }
      },
    );
  }
}

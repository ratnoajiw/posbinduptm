import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/entities/kolesterol_total_entity.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/usecases/delete_kolesterol_total.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/usecases/get_all_kolesterol_total.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/usecases/update_kolesterol_total.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/usecases/upload_kolesterol_total.dart';

part 'kolesterol_total_event.dart';
part 'kolesterol_total_state.dart';

class KolesterolTotalBloc
    extends Bloc<KolesterolTotalEvent, KolesterolTotalState> {
  final UploadKolesterolTotal _uploadKolesterolTotal;
  final GetAllKolesterolTotal _getAllKolesterolTotal;
  final DeleteKolesterolTotal _deleteKolesterolTotal;
  final UpdateKolesterolTotal _updateKolesterolTotal;

  KolesterolTotalBloc({
    required UploadKolesterolTotal uploadKolesterolTotal,
    required GetAllKolesterolTotal getAllKolesterolTotal,
    required DeleteKolesterolTotal deleteKolesterolTotal,
    required UpdateKolesterolTotal updateKolesterolTotal,
  })  : _uploadKolesterolTotal = uploadKolesterolTotal,
        _getAllKolesterolTotal = getAllKolesterolTotal,
        _deleteKolesterolTotal = deleteKolesterolTotal,
        _updateKolesterolTotal = updateKolesterolTotal,
        super(KolesterolTotalInitial()) {
    on<KolesterolTotalUpload>(_onUploadKolesterolTotal);
    on<KolesterolTotalUpdate>(_onUpdateKolesterolTotal);
    on<KolesterolTotalList>(_onGetAllKolesterolTotal);
    on<KolesterolTotalDelete>(_onDeleteKolesterolTotal);
  }

  // Ambil semua data pemeriksaan kolesterol total berdasarkan profileId
  void _onGetAllKolesterolTotal(
      KolesterolTotalList event, Emitter<KolesterolTotalState> emit) async {
    emit(KolesterolTotalLoading());
    final result = await _getAllKolesterolTotal(
        GetAllKolesterolTotalParams(profileId: event.profileId));
    result.fold(
      (failure) => emit(KolesterolTotalFailure(failure.message)),
      (data) => emit(KolesterolTotalDisplaySuccess(data)),
    );
  }

  // Upload data pemeriksaan kolesterol total baru
  void _onUploadKolesterolTotal(
      KolesterolTotalUpload event, Emitter<KolesterolTotalState> emit) async {
    emit(KolesterolTotalLoading());
    final result = await _uploadKolesterolTotal(UploadKolesterolTotalParams(
      profileId: event.profileId,
      kolesterolTotal: event.kolesterolTotal,
      pemeriksaanAt: event.pemeriksaanAt,
    ));
    result.fold(
      (failure) => emit(KolesterolTotalFailure(failure.message)),
      (_) => emit(KolesterolTotalUploadSuccess()),
    );
  }

  // Update data pemeriksaan kolesterol total
  void _onUpdateKolesterolTotal(
      KolesterolTotalUpdate event, Emitter<KolesterolTotalState> emit) async {
    emit(KolesterolTotalLoading());
    final result = await _updateKolesterolTotal(UpdateKolesterolTotalParams(
      kolesterolTotalId: event.kolesterolTotalId,
      kolesterolTotal: event.kolesterolTotal,
      pemeriksaanAt: event.pemeriksaanAt,
    ));
    result.fold(
      (failure) => emit(KolesterolTotalFailure(failure.message)),
      (data) => emit(KolesterolTotalUpdateSuccess()),
    );
  }

  // Hapus data pemeriksaan kolesterol total berdasarkan ID
  void _onDeleteKolesterolTotal(
      KolesterolTotalDelete event, Emitter<KolesterolTotalState> emit) async {
    emit(KolesterolTotalLoading());
    final result = await _deleteKolesterolTotal(DeleteKolesterolTotalParams(
        kolesterolTotalId: event.kolesterolTotalId));
    result.fold(
      (failure) => emit(KolesterolTotalFailure(failure.message)),
      (_) => emit(KolesterolTotalDeleteSuccess()),
    );
  }
}

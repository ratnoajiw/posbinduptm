import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/features/periksa_antropometri/domain/entities/antropometri_entity.dart';
import 'package:posbinduptm/features/periksa_antropometri/domain/usecases/delete_antropometri.dart';
import 'package:posbinduptm/features/periksa_antropometri/domain/usecases/get_all_antropometri.dart';
import 'package:posbinduptm/features/periksa_antropometri/domain/usecases/update_antropometri.dart';
import 'package:posbinduptm/features/periksa_antropometri/domain/usecases/upload_antropometri.dart';

part 'antropometri_event.dart';
part 'antropometri_state.dart';

class AntropometriBloc extends Bloc<AntropometriEvent, AntropometriState> {
  //panggil usecase
  final UploadAntropometri _uploadAntropometri;
  final GetAllAntropometri _getAllAntropometri;
  final DeleteAntropometri _deleteAntropometri;
  final UpdateAntropometri _updateAntropometri;

  AntropometriBloc({
    required UploadAntropometri uploadAntropometri,
    required GetAllAntropometri getAllAntropometri,
    required DeleteAntropometri deleteAntropometri,
    required UpdateAntropometri updateAntropometri,
  })  : _uploadAntropometri = uploadAntropometri,
        _getAllAntropometri = getAllAntropometri,
        _deleteAntropometri = deleteAntropometri,
        _updateAntropometri = updateAntropometri,
        super(AntropometriInitial()) {
    on<AntropometriEvent>((event, emit) => emit(AntropometriLoading()));
    on<AntropometriUpload>(_onUploadAntropometri);
    on<AntropometriGetAllAntropometriList>(_onGetAllAntropometris);
    on<AntropometriDelete>(_onDeleteAntropometri);
    on<AntropometriUpdate>(_onUpdateAntropometri);
  }

  void _onUploadAntropometri(
      AntropometriUpload event, Emitter<AntropometriState> emit) async {
    final res = await _uploadAntropometri(
      UploadAntropometriParams(
        posterId: event.posterId,
        tinggiBadan: event.tinggiBadan,
        beratBadan: event.beratBadan,
        lingkarPerut: event.lingkarPerut,
        pemeriksaanAt: event.pemeriksaanAt,
      ),
    );

    res.fold(
      (l) => emit(AntropometriFailure(l.message)),
      (r) => emit(AntropometriUploadSuccess()),
    );
  }

  void _onGetAllAntropometris(AntropometriGetAllAntropometriList event,
      Emitter<AntropometriState> emit) async {
    final res = await _getAllAntropometri(
        GetAllAntropometriParams(posterId: event.posterId));

    res.fold(
      (l) => emit(AntropometriFailure(l.message)),
      (r) => emit(AntropometrisDisplaySuccess(r)),
    );
  }

  void _onUpdateAntropometri(
      AntropometriUpdate event, Emitter<AntropometriState> emit) async {
    emit(AntropometriLoading());

    final res = await _updateAntropometri(
      UpdateAntropometriParams(
        id: event.id,
        tinggiBadan: event.tinggiBadan,
        beratBadan: event.beratBadan,
        lingkarPerut: event.lingkarPerut,
        pemeriksaanAt: event.pemeriksaanAt,
      ),
    );

    res.fold(
      (l) {
        emit(AntropometriFailure(l.message));
      },
      (r) {
        emit(AntropometriUpdateSuccess());
      },
    );
  }

  void _onDeleteAntropometri(
      AntropometriDelete event, Emitter<AntropometriState> emit) async {
    final res = await _deleteAntropometri(
        DeleteAntropometriParams(antropometriId: event.antropometriId));

    res.fold(
      (l) => emit(AntropometriFailure(l.message)),
      (r) => emit(AntropometriDeleteSuccess()),
    );
  }
}

part of 'antropometri_bloc.dart';

sealed class AntropometriEvent {}

final class AntropometriUpload extends AntropometriEvent {
  final String posterId;
  final String tanggal;
  final double beratBadan;
  final double tinggiBadan;
  final double lingkarPerut;

  AntropometriUpload({
    required this.posterId,
    required this.tanggal,
    required this.beratBadan,
    required this.tinggiBadan,
    required this.lingkarPerut,
  });
}

class AntropometriGetAllAntropometris extends AntropometriEvent {
  final String posterId;

  AntropometriGetAllAntropometris({required this.posterId});
}

class AntropometriDelete extends AntropometriEvent {
  final String antropometriId;

  AntropometriDelete({
    required this.antropometriId,
  });
}

class AntropometriUpdate extends AntropometriEvent {
  final String id;
  final double beratBadan;
  final double tinggiBadan;
  final double lingkarPerut;

  AntropometriUpdate({
    required this.id,
    required this.beratBadan,
    required this.tinggiBadan,
    required this.lingkarPerut,
  });
}

class AntropometriGetAntropometri extends AntropometriEvent {
  final String antropometriId;

  AntropometriGetAntropometri({required this.antropometriId});
}

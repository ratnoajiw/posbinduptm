part of 'antropometri_bloc.dart';

sealed class AntropometriEvent {}

final class AntropometriUpload extends AntropometriEvent {
  final String posterId;
  final String updateAt;
  final double beratBadan;
  final double tinggiBadan;
  final double lingkarPerut;
  final DateTime pemeriksaanAt;

  AntropometriUpload({
    required this.posterId,
    required this.updateAt,
    required this.beratBadan,
    required this.tinggiBadan,
    required this.lingkarPerut,
    required this.pemeriksaanAt,
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
  final DateTime pemeriksaanAt;

  AntropometriUpdate({
    required this.id,
    required this.beratBadan,
    required this.tinggiBadan,
    required this.lingkarPerut,
    required this.pemeriksaanAt,
  });
}

class AntropometriGetAntropometri extends AntropometriEvent {
  final String antropometriId;

  AntropometriGetAntropometri({required this.antropometriId});
}

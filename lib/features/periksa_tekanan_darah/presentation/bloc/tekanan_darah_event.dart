part of 'tekanan_darah_bloc.dart';

sealed class TekananDarahEvent extends Equatable {
  const TekananDarahEvent();

  @override
  List<Object> get props => [];
}

final class TekananDarahUpload extends TekananDarahEvent {
  final String profileId;
  final double sistolik;
  final double diastolik;
  final DateTime pemeriksaanAt;

  const TekananDarahUpload({
    required this.profileId,
    required this.sistolik,
    required this.diastolik,
    required this.pemeriksaanAt,
  });
}

class TekananDarahUpdate extends TekananDarahEvent {
  final String tekananDarahId;
  final double sistolik;
  final double diastolik;
  final DateTime pemeriksaanAt;

  const TekananDarahUpdate({
    required this.tekananDarahId,
    required this.sistolik,
    required this.diastolik,
    required this.pemeriksaanAt,
  });
}

class TekananDarahList extends TekananDarahEvent {
  final String profileId;
  const TekananDarahList({required this.profileId});
}

class TekananDarahDelete extends TekananDarahEvent {
  final String tekananDarahId;
  const TekananDarahDelete({required this.tekananDarahId});
}

class TekananDarahGet extends TekananDarahEvent {
  final String tekananDarahId;
  const TekananDarahGet({required this.tekananDarahId});
}

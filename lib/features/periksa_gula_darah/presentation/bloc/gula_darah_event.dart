part of 'gula_darah_bloc.dart';

sealed class GulaDarahEvent extends Equatable {
  const GulaDarahEvent();

  @override
  List<Object> get props => [];
}

final class GulaDarahUpload extends GulaDarahEvent {
  final String profileId;
  final String updateAt;
  final double gulaDarahSewaktu;
  final DateTime pemeriksaanAt;

  const GulaDarahUpload({
    required this.profileId,
    required this.updateAt,
    required this.gulaDarahSewaktu,
    required this.pemeriksaanAt,
  });
}

class GulaDarahUpdate extends GulaDarahEvent {
  final String gulaDarahId;
  final double gulaDarahSewaktu;
  final DateTime pemeriksaanAt;

  const GulaDarahUpdate({
    required this.gulaDarahId,
    required this.gulaDarahSewaktu,
    required this.pemeriksaanAt,
  });
}

class GulaDarahList extends GulaDarahEvent {
  final String profileId;
  const GulaDarahList({required this.profileId});
}

class GulaDarahDelete extends GulaDarahEvent {
  final String gulaDarahSewaktuId;
  const GulaDarahDelete({required this.gulaDarahSewaktuId});
}

class GulaDarahGet extends GulaDarahEvent {
  final String gulaDarahSewaktuId;
  const GulaDarahGet({required this.gulaDarahSewaktuId});
}

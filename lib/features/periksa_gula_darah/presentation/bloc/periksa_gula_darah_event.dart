part of 'periksa_gula_darah_bloc.dart';

sealed class PeriksaGulaDarahEvent extends Equatable {
  const PeriksaGulaDarahEvent();

  @override
  List<Object> get props => [];
}

final class PeriksaGulaDarahUpload extends PeriksaGulaDarahEvent {
  final String profileId;
  final String updateAt;
  final double gulaDarahSewaktu;
  final DateTime pemeriksaanAt;

  const PeriksaGulaDarahUpload({
    required this.profileId,
    required this.updateAt,
    required this.gulaDarahSewaktu,
    required this.pemeriksaanAt,
  });
}

class PeriksaGulaDarahUpdate extends PeriksaGulaDarahEvent {
  final String id;
  final double gulaDarahSewaktu;
  final DateTime pemeriksaanAt;

  const PeriksaGulaDarahUpdate({
    required this.id,
    required this.gulaDarahSewaktu,
    required this.pemeriksaanAt,
  });
}

class PeriksaGulaDarahList extends PeriksaGulaDarahEvent {
  final String profileId;
  const PeriksaGulaDarahList({required this.profileId});
}

class PeriksaGulaDarahDelete extends PeriksaGulaDarahEvent {
  final String gulaDarahSewaktuId;
  const PeriksaGulaDarahDelete({required this.gulaDarahSewaktuId});
}

class PeriksaGulaDarahGet extends PeriksaGulaDarahEvent {
  final String gulaDarahSewaktuId;
  const PeriksaGulaDarahGet({required this.gulaDarahSewaktuId});
}

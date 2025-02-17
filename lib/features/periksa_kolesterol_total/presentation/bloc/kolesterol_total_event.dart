part of 'kolesterol_total_bloc.dart';

sealed class KolesterolTotalEvent extends Equatable {
  const KolesterolTotalEvent();

  @override
  List<Object> get props => [];
}

final class KolesterolTotalUpload extends KolesterolTotalEvent {
  final String profileId;
  final double kolesterolTotal;
  final DateTime pemeriksaanAt;

  const KolesterolTotalUpload({
    required this.profileId,
    required this.kolesterolTotal,
    required this.pemeriksaanAt,
  });
}

class KolesterolTotalUpdate extends KolesterolTotalEvent {
  final String kolesterolTotalId;
  final double kolesterolTotal;
  final DateTime pemeriksaanAt;

  const KolesterolTotalUpdate({
    required this.kolesterolTotalId,
    required this.kolesterolTotal,
    required this.pemeriksaanAt,
  });
}

class KolesterolTotalList extends KolesterolTotalEvent {
  final String profileId;
  const KolesterolTotalList({required this.profileId});
}

class KolesterolTotalDelete extends KolesterolTotalEvent {
  final String kolesterolTotalId;
  const KolesterolTotalDelete({required this.kolesterolTotalId});
}

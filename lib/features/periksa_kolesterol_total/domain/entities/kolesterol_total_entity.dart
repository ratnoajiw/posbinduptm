class KolesterolTotalEntity {
  final String kolesterolTotalId;
  final DateTime updatedAt;
  final String profileId;
  final double kolesterolTotal;
  final DateTime pemeriksaanAt;
  final String? profileName;

  KolesterolTotalEntity({
    required this.kolesterolTotalId,
    required this.updatedAt,
    required this.profileId,
    required this.kolesterolTotal,
    required this.pemeriksaanAt,
    this.profileName,
  });
}

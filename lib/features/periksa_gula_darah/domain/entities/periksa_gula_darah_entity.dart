class PeriksaGulaDarahEntity {
  final String id;
  final DateTime updatedAt;
  final String profileId;
  final double gulaDarahSewaktu;
  final DateTime pemeriksaanAt;
  final String? profileName;

  PeriksaGulaDarahEntity({
    required this.id,
    required this.updatedAt,
    required this.profileId,
    required this.gulaDarahSewaktu,
    required this.pemeriksaanAt,
    this.profileName,
  });
}

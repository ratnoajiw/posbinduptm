class GulaDarahEntity {
  final String gulaDarahId;
  final DateTime updatedAt;
  final String profileId;
  final double gulaDarahSewaktu;
  final DateTime pemeriksaanAt;
  final String? profileName;

  GulaDarahEntity({
    required this.gulaDarahId,
    required this.updatedAt,
    required this.profileId,
    required this.gulaDarahSewaktu,
    required this.pemeriksaanAt,
    this.profileName,
  });
}

class TekananDarahEntity {
  final String tekananDarahId;
  final DateTime updatedAt;
  final String profileId;
  final double sistolik;
  final double diastolik;
  final DateTime pemeriksaanAt;
  final String? profileName;

  TekananDarahEntity({
    required this.tekananDarahId,
    required this.updatedAt,
    required this.profileId,
    required this.sistolik,
    required this.diastolik,
    required this.pemeriksaanAt,
    this.profileName,
  });
}

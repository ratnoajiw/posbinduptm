class AntropometriEntity {
  final String id;
  final DateTime updatedAt;
  final String posterId;
  final double tinggiBadan;
  final double beratBadan;
  final double lingkarPerut;
  final double imtPasien;
  final String? posterName;

  AntropometriEntity({
    required this.id,
    required this.updatedAt,
    required this.posterId,
    required this.tinggiBadan,
    required this.beratBadan,
    required this.lingkarPerut,
    required this.imtPasien,
    this.posterName,
  });
}

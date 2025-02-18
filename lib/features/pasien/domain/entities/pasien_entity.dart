class PasienEntity {
  final String pasienId;
  final String profileId;
  final String? nik;
  final String? jenisKelamin;
  final DateTime? tanggalLahir;
  final String? alamat;
  final String? nomorHp;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? profileName;

  PasienEntity({
    required this.pasienId,
    required this.profileId,
    this.nik,
    this.jenisKelamin,
    this.tanggalLahir,
    this.alamat,
    this.nomorHp,
    required this.createdAt,
    required this.updatedAt,
    this.profileName,
  });
}

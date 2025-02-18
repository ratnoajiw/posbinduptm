import 'package:posbinduptm/features/pasien/domain/entities/pasien_entity.dart';

class PasienModel extends PasienEntity {
  PasienModel({
    required super.pasienId,
    required super.profileId,
    super.nik,
    super.tanggalLahir,
    super.jenisKelamin,
    super.alamat,
    super.nomorHp,
    required super.createdAt,
    required super.updatedAt,
    super.profileName,
  });

  factory PasienModel.fromJson(Map<String, dynamic> map) {
    return PasienModel(
      pasienId: map['pasien_id'] as String,
      profileId: map['profile_id'] as String,
      nik: map['nik'] as String?,
      jenisKelamin: map['jenis_kelamin'] as String?,
      tanggalLahir: map['tanggal_lahir'] == null
          ? null
          : DateTime.parse(map['tanggal_lahir']),
      alamat: map['alamat'] as String?,
      nomorHp: map['nomor_hp'] as String?,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      profileName: map['profiles'] != null && map['profiles']['name'] != null
          ? map['profiles']['name'] as String
          : null, // Ambil profileName dari profiles
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pasien_id': pasienId,
      'profile_id': profileId,
      'nik': nik,
      'jenis_kelamin': jenisKelamin,
      'tanggal_lahir': tanggalLahir
          ?.toIso8601String()
          .split(' ')[0], // Ambil hanya bagian tanggal
      'alamat': alamat,
      'nomor_hp': nomorHp,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  PasienModel copyWith({
    String? pasienId,
    String? profileId,
    String? nik,
    DateTime? tanggalLahir,
    String? jenisKelamin,
    String? alamat,
    String? nomorHp,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profileName, // Tambahkan profileName
  }) {
    return PasienModel(
      pasienId: pasienId ?? this.pasienId,
      profileId: profileId ?? this.profileId,
      nik: nik ?? this.nik,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      alamat: alamat ?? this.alamat,
      nomorHp: nomorHp ?? this.nomorHp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profileName: profileName ?? this.profileName, // Tambahkan profileName
    );
  }
}

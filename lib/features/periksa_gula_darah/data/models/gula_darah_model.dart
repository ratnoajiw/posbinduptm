import 'package:posbinduptm/features/periksa_gula_darah/domain/entities/gula_darah_entity.dart';

class GulaDarahModel extends GulaDarahEntity {
  GulaDarahModel({
    required super.gulaDarahId,
    required super.profileId,
    required super.updatedAt,
    required super.pemeriksaanAt,
    required super.gulaDarahSewaktu,
    super.profileName,
  });

  factory GulaDarahModel.fromJson(Map<String, dynamic> map) {
    return GulaDarahModel(
      gulaDarahId: map['gula_darah_id'] as String,
      profileId: map['profile_id'] as String,
      gulaDarahSewaktu: (map['gula_darah_sewaktu'] as num).toDouble(),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
      pemeriksaanAt: DateTime.parse(map['pemeriksaan_at']),
      profileName: map['profiles']?['name'] ?? 'Tidak diketahui',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gula_darah_id': gulaDarahId,
      'profile_id': profileId,
      'gula_darah_sewaktu': gulaDarahSewaktu,
      'updated_at': updatedAt.toIso8601String(),
      'pemeriksaan_at': pemeriksaanAt.toIso8601String(),
    };
  }

  GulaDarahModel copyWith({
    String? gulaDarahId,
    String? profileId,
    double? gulaDarahSewaktu,
    DateTime? updatedAt,
    DateTime? pemeriksaanAt,
    String? profileName,
  }) {
    return GulaDarahModel(
      gulaDarahId: gulaDarahId ?? this.gulaDarahId,
      profileId: profileId ?? this.profileId,
      gulaDarahSewaktu: gulaDarahSewaktu ?? this.gulaDarahSewaktu,
      updatedAt: updatedAt ?? this.updatedAt,
      pemeriksaanAt: pemeriksaanAt ?? this.pemeriksaanAt,
      profileName: profileName ?? this.profileName,
    );
  }
}

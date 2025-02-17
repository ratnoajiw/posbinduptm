import 'package:posbinduptm/features/periksa_tekanan_darah/domain/entities/tekanan_darah_entity.dart';

class TekananDarahModel extends TekananDarahEntity {
  TekananDarahModel({
    required super.tekananDarahId,
    required super.profileId,
    required super.updatedAt,
    required super.pemeriksaanAt,
    required super.sistolik,
    required super.diastolik,
    super.profileName,
  });

  factory TekananDarahModel.fromJson(Map<String, dynamic> map) {
    return TekananDarahModel(
      tekananDarahId: map['tekanan_darah_id'] as String,
      profileId: map['profile_id'] as String,
      sistolik: (map['sistolik'] as num).toDouble(),
      diastolik: (map['diastolik'] as num).toDouble(),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
      pemeriksaanAt: DateTime.parse(map['pemeriksaan_at']),
      profileName: map['profiles']?['name'] ?? 'Tidak diketahui',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tekanan_darah_id': tekananDarahId,
      'profile_id': profileId,
      'sistolik': sistolik,
      'diastolik': diastolik,
      'updated_at': updatedAt.toIso8601String(),
      'pemeriksaan_at': pemeriksaanAt.toIso8601String(),
    };
  }

  TekananDarahModel copyWith({
    String? tekananDarahId,
    String? profileId,
    double? sistolik,
    double? diastolik,
    DateTime? updatedAt,
    DateTime? pemeriksaanAt,
    String? profileName,
  }) {
    return TekananDarahModel(
      tekananDarahId: tekananDarahId ?? this.tekananDarahId,
      profileId: profileId ?? this.profileId,
      sistolik: sistolik ?? this.sistolik,
      diastolik: diastolik ?? this.diastolik,
      updatedAt: updatedAt ?? this.updatedAt,
      pemeriksaanAt: pemeriksaanAt ?? this.pemeriksaanAt,
      profileName: profileName ?? this.profileName,
    );
  }
}

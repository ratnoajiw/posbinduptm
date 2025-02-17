import 'package:posbinduptm/features/periksa_kolesterol_total/domain/entities/kolesterol_total_entity.dart';

class KolesterolTotalModel extends KolesterolTotalEntity {
  KolesterolTotalModel({
    required super.kolesterolTotalId,
    required super.profileId,
    required super.updatedAt,
    required super.pemeriksaanAt,
    required super.kolesterolTotal,
    super.profileName,
  });

  factory KolesterolTotalModel.fromJson(Map<String, dynamic> map) {
    return KolesterolTotalModel(
      kolesterolTotalId: map['kolesterol_total_id'] as String,
      profileId: map['profile_id'] as String,
      kolesterolTotal: (map['kolesterol_total'] as num).toDouble(),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
      pemeriksaanAt: DateTime.parse(map['pemeriksaan_at']),
      profileName: map['profiles']?['name'] ?? 'Tidak diketahui',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kolesterol_total_id': kolesterolTotalId,
      'profile_id': profileId,
      'kolesterol_total': kolesterolTotal,
      'updated_at': updatedAt.toIso8601String(),
      'pemeriksaan_at': pemeriksaanAt.toIso8601String(),
    };
  }

  KolesterolTotalModel copyWith({
    String? kolesterolTotalId,
    String? profileId,
    double? kolesterolTotal,
    DateTime? updatedAt,
    DateTime? pemeriksaanAt,
    String? profileName,
  }) {
    return KolesterolTotalModel(
      kolesterolTotalId: kolesterolTotalId ?? this.kolesterolTotalId,
      profileId: profileId ?? this.profileId,
      kolesterolTotal: kolesterolTotal ?? this.kolesterolTotal,
      updatedAt: updatedAt ?? this.updatedAt,
      pemeriksaanAt: pemeriksaanAt ?? this.pemeriksaanAt,
      profileName: profileName ?? this.profileName,
    );
  }
}

import 'package:posbinduptm/features/antropometri/domain/entities/antropometri_entity.dart';

class AntropometriModel extends AntropometriEntity {
  AntropometriModel({
    required super.id,
    required super.posterId,
    required super.tinggiBadan,
    required super.beratBadan,
    required super.lingkarPerut,
    required super.imtPasien,
    required super.updatedAt,
    required super.posterName,
  });

  factory AntropometriModel.fromJson(Map<String, dynamic> map) {
    return AntropometriModel(
      id: map['id'] as String,
      posterId: map['poster_id'] as String,
      tinggiBadan: map['tinggi_badan'].toDouble(),
      beratBadan: map['berat_badan'].toDouble(),
      lingkarPerut: map['lingkar_perut'].toDouble(),
      imtPasien: map['imt'].toDouble(),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
      posterName: map['profiles']?['name'] ?? 'Tidak diketahui',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'tinggi_badan': tinggiBadan,
      'berat_badan': beratBadan,
      'lingkar_perut': lingkarPerut,
      'imt': imtPasien,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AntropometriModel copyWith({
    String? id,
    String? posterId,
    double? tinggiBadan,
    double? beratBadan,
    double? lingkarPerut,
    double? imtPasien,
    DateTime? updatedAt,
    String? posterName,
  }) {
    return AntropometriModel(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      tinggiBadan: tinggiBadan ?? this.tinggiBadan,
      beratBadan: beratBadan ?? this.beratBadan,
      lingkarPerut: lingkarPerut ?? this.lingkarPerut,
      imtPasien: imtPasien ?? this.imtPasien,
      updatedAt: updatedAt ?? this.updatedAt,
      posterName: posterName ?? this.posterName,
    );
  }
}

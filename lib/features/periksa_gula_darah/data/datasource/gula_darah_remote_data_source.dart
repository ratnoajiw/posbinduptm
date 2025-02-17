import 'package:posbinduptm/core/error/exceptions.dart';
import 'package:posbinduptm/features/periksa_gula_darah/data/models/gula_darah_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract interface class GulaDarahRemoteDataSource {
  Future<List<GulaDarahModel>> getAllGulaDarah({
    required String profileId,
  });

  Future<GulaDarahModel?> getLatestGulaDarah({
    required String profileId,
  });

  Future<GulaDarahModel> uploadGulaDarah(
    GulaDarahModel gulaDarahModel,
  );

  Future<GulaDarahModel> updateGulaDarah({
    required String gulaDarahId,
    required double gulaDarahSewaktu,
    required DateTime pemeriksaanAt,
  });

  Future<void> deleteGulaDarah(String gulaDarahId);
}

class GulaDarahRemoteDataSourceImpl implements GulaDarahRemoteDataSource {
  final SupabaseClient supabaseClient;
  GulaDarahRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<GulaDarahModel>> getAllGulaDarah({
    required String profileId,
  }) async {
    try {
      final results = await supabaseClient
          .from('periksa_gula_darah')
          .select('*, profiles(name)')
          .eq('profile_id', profileId)
          .order('pemeriksaan_at', ascending: false);

      return results.map((periksaGulaDarah) {
        return GulaDarahModel.fromJson(periksaGulaDarah).copyWith(
          profileName: periksaGulaDarah['profiles']?['name'],
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<GulaDarahModel?> getLatestGulaDarah({
    required String profileId,
  }) async {
    try {
      final results = await supabaseClient
          .from('periksa_gula_darah')
          .select()
          .eq('profile_id', profileId)
          .order('pemeriksaan_at', ascending: false)
          .limit(1);

      if (results.isEmpty) return null;
      return GulaDarahModel.fromJson(results.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<GulaDarahModel> uploadGulaDarah(GulaDarahModel gulaDarahModel) async {
    try {
      final uploadData = await supabaseClient
          .from('periksa_gula_darah')
          .insert(
              gulaDarahModel.copyWith(gulaDarahId: const Uuid().v4()).toJson())
          .select();

      return GulaDarahModel.fromJson(uploadData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<GulaDarahModel> updateGulaDarah(
      {required String gulaDarahId,
      required double gulaDarahSewaktu,
      required DateTime pemeriksaanAt}) async {
    try {
      final updateData = <String, dynamic>{
        'pemeriksaan_at': pemeriksaanAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'gula_darah_sewaktu': gulaDarahSewaktu,
      };

      final updatedData = await supabaseClient
          .from('periksa_gula_darah')
          .update(updateData)
          .eq('gula_darah_id', gulaDarahId)
          .select();

      if (updatedData.isEmpty) {
        throw const ServerException(
            "Data tidak ditemukan atau gagal diperbarui");
      }

      return GulaDarahModel.fromJson(updatedData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<void> deleteGulaDarah(String gulaDarahId) async {
    try {
      await supabaseClient
          .from('periksa_gula_darah')
          .delete()
          .match({'gula_darah_id': gulaDarahId});
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }
}

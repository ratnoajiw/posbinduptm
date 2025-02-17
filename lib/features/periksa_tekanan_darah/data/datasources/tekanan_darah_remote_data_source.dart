import 'package:posbinduptm/core/error/exceptions.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/data/models/tekanan_darah_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract interface class TekananDarahRemoteDataSource {
  Future<List<TekananDarahModel>> getAllTekananDarah({
    required String profileId,
  });

  Future<TekananDarahModel?> getLatestTekananDarah({
    required String profileId,
  });

  Future<TekananDarahModel> uploadTekananDarah(
    TekananDarahModel tekananDarahModel,
  );

  Future<TekananDarahModel> updateTekananDarah({
    required String tekananDarahId,
    required double sistolik,
    required double diastolik,
    required DateTime pemeriksaanAt,
  });

  Future<void> deleteTekananDarah(String tekananDarahId);
}

class TekananDarahRemoteDataSourceImpl implements TekananDarahRemoteDataSource {
  final SupabaseClient supabaseClient;

  TekananDarahRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<TekananDarahModel>> getAllTekananDarah({
    required String profileId,
  }) async {
    try {
      final results = await supabaseClient
          .from('periksa_tekanan_darah')
          .select('*, profiles(name)')
          .eq('profile_id', profileId)
          .order('pemeriksaan_at', ascending: false);

      return results.map((tekananDarah) {
        return TekananDarahModel.fromJson(tekananDarah).copyWith(
          profileName: tekananDarah['profiles']?['name'],
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<TekananDarahModel?> getLatestTekananDarah({
    required String profileId,
  }) async {
    try {
      final results = await supabaseClient
          .from('periksa_tekanan_darah')
          .select()
          .eq('profile_id', profileId)
          .order('pemeriksaan_at', ascending: false)
          .limit(1);

      if (results.isEmpty) return null;
      return TekananDarahModel.fromJson(results.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<TekananDarahModel> uploadTekananDarah(
      TekananDarahModel tekananDarahModel) async {
    try {
      final uploadData = await supabaseClient
          .from('periksa_tekanan_darah')
          .insert(tekananDarahModel
              .copyWith(tekananDarahId: const Uuid().v4())
              .toJson())
          .select();

      return TekananDarahModel.fromJson(uploadData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TekananDarahModel> updateTekananDarah({
    required String tekananDarahId,
    required double sistolik,
    required double diastolik,
    required DateTime pemeriksaanAt,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'pemeriksaan_at': pemeriksaanAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'sistolik': sistolik,
        'diastolik': diastolik,
      };

      final updatedData = await supabaseClient
          .from('periksa_tekanan_darah')
          .update(updateData)
          .eq('tekanan_darah_id', tekananDarahId)
          .select();

      if (updatedData.isEmpty) {
        throw const ServerException(
            "Data tidak ditemukan atau gagal diperbarui");
      }

      return TekananDarahModel.fromJson(updatedData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<void> deleteTekananDarah(String tekananDarahId) async {
    try {
      await supabaseClient
          .from('periksa_tekanan_darah')
          .delete()
          .match({'tekanan_darah_id': tekananDarahId});
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }
}

import 'package:posbinduptm/core/error/exceptions.dart';
import 'package:posbinduptm/features/periksa_gula_darah/data/models/periksa_gula_darah_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract interface class PeriksaGulaDarahRemoteDataSource {
  Future<List<PeriksaGulaDarahModel>> getAllPeriksaGulaDarah({
    required String profileId,
  });

  Future<PeriksaGulaDarahModel?> getLatestPeriksaGulaDarah({
    required String profileId,
  });

  Future<PeriksaGulaDarahModel> uploadPeriksaGulaDarah(
    PeriksaGulaDarahModel periksaGulaDarah,
  );

  Future<PeriksaGulaDarahModel> updatePeriksaGulaDarah({
    required String gulaDarahId,
    required double gulaDarahSewaktu,
    required DateTime periksaAt,
  });

  Future<void> deletePeriksaGulaDarah(String periksaGulaDarahId);
}

class PeriksaGulaDarahRemoteDataSourceImpl
    implements PeriksaGulaDarahRemoteDataSource {
  final SupabaseClient supabaseClient;
  PeriksaGulaDarahRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<PeriksaGulaDarahModel>> getAllPeriksaGulaDarah({
    required String profileId,
  }) async {
    try {
      final results = await supabaseClient
          .from('periksa_gula_darah')
          .select('*, profiles(name)')
          .eq('profile_id', profileId)
          .order('pemeriksaan_at', ascending: false);

      return results.map((periksa) {
        return PeriksaGulaDarahModel.fromJson(periksa).copyWith(
          profileName: periksa['profiles']?['name'],
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<PeriksaGulaDarahModel?> getLatestPeriksaGulaDarah({
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
      return PeriksaGulaDarahModel.fromJson(results.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<PeriksaGulaDarahModel> uploadPeriksaGulaDarah(
      PeriksaGulaDarahModel periksaGulaDarah) async {
    try {
      final periksaData = await supabaseClient
          .from('periksa_gula_darah')
          .insert(periksaGulaDarah.copyWith(id: const Uuid().v4()).toJson())
          .select();

      return PeriksaGulaDarahModel.fromJson(periksaData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PeriksaGulaDarahModel> updatePeriksaGulaDarah({
    required String gulaDarahId,
    required double gulaDarahSewaktu,
    required DateTime periksaAt,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'pemeriksaan_at': periksaAt.toIso8601String(),
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

      return PeriksaGulaDarahModel.fromJson(updatedData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<void> deletePeriksaGulaDarah(String periksaGulaDarahId) async {
    try {
      await supabaseClient
          .from('periksa_gula_darah')
          .delete()
          .match({'gula_darah_id': periksaGulaDarahId});
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }
}

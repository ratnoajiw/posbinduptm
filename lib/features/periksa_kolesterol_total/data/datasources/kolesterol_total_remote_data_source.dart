import 'package:posbinduptm/core/error/exceptions.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/data/models/kolesterol_total_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract interface class KolesterolTotalRemoteDataSource {
  Future<List<KolesterolTotalModel>> getAllKolesterolTotal({
    required String profileId,
  });

  Future<KolesterolTotalModel> uploadKolesterolTotal(
    KolesterolTotalModel kolesterolTotalModel,
  );

  Future<KolesterolTotalModel> updateKolesterolTotal({
    required String kolesterolTotalId,
    required double kolesterolTotal,
    required DateTime pemeriksaanAt,
  });

  Future<void> deleteKolesterolTotal(String kolesterolTotalId);
}

class KolesterolTotalRemoteDataSourceImpl
    implements KolesterolTotalRemoteDataSource {
  final SupabaseClient supabaseClient;

  KolesterolTotalRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<KolesterolTotalModel>> getAllKolesterolTotal({
    required String profileId,
  }) async {
    try {
      final results = await supabaseClient
          .from('periksa_kolesterol_total')
          .select('*, profiles(name)')
          .eq('profile_id', profileId)
          .order('pemeriksaan_at', ascending: false);

      return results.map((kolesterolTotal) {
        return KolesterolTotalModel.fromJson(kolesterolTotal).copyWith(
          profileName: kolesterolTotal['profiles']?['name'],
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<KolesterolTotalModel> uploadKolesterolTotal(
      KolesterolTotalModel kolesterolTotalModel) async {
    try {
      final uploadData = await supabaseClient
          .from('periksa_kolesterol_total')
          .insert(kolesterolTotalModel
              .copyWith(kolesterolTotalId: const Uuid().v4())
              .toJson())
          .select();

      return KolesterolTotalModel.fromJson(uploadData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<KolesterolTotalModel> updateKolesterolTotal({
    required String kolesterolTotalId,
    required double kolesterolTotal,
    required DateTime pemeriksaanAt,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'pemeriksaan_at': pemeriksaanAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'kolesterol_total': kolesterolTotal,
      };

      final updatedData = await supabaseClient
          .from('periksa_kolesterol_total')
          .update(updateData)
          .eq('kolesterol_total_id', kolesterolTotalId)
          .select();

      if (updatedData.isEmpty) {
        throw const ServerException(
            "Data tidak ditemukan atau gagal diperbarui");
      }

      return KolesterolTotalModel.fromJson(updatedData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<void> deleteKolesterolTotal(String kolesterolTotalId) async {
    try {
      await supabaseClient
          .from('periksa_kolesterol_total')
          .delete()
          .match({'kolesterol_total_id': kolesterolTotalId});
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }
}

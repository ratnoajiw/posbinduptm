import 'package:posbinduptm/core/error/exceptions.dart';
import 'package:posbinduptm/features/antropometri/data/models/antropometri_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AntropometriRemoteDataSource {
  Future<List<AntropometriModel>> getAllAntropometri({
    required String posterId,
  });
  Future<AntropometriModel> uploadAntropometri(
    AntropometriModel antropometri,
  );
  Future<void> updateAntropometri({
    required String id,
    required double tinggiBadan,
    required double beratBadan,
    required double lingkarPerut,
  });
  Future<void> deleteAntropometri(
    String antropometriId,
  );
}

class AntropometriRemoteDataSourceImpl implements AntropometriRemoteDataSource {
  final SupabaseClient supabaseClient;
  AntropometriRemoteDataSourceImpl(
    this.supabaseClient,
  );

  @override
  Future<void> deleteAntropometri(String antropometriId) async {
    try {
      await supabaseClient
          .from('antropometri')
          .delete()
          .match({'id': antropometriId});
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<List<AntropometriModel>> getAllAntropometri(
      {required String posterId}) async {
    try {
      final antropometries = await supabaseClient
          .from('antropometri')
          .select('*, profiles(name)')
          .eq('poster_id', posterId);

      return antropometries.map((antropometri) {
        return AntropometriModel.fromJson(antropometri).copyWith(
          posterName: antropometri['profiles']
              ?['name'], // Pastikan 'profiles' tidak null
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<AntropometriModel> uploadAntropometri(
      AntropometriModel antropometri) async {
    try {
      final antropometriData = await supabaseClient
          .from('antropometri')
          .insert(antropometri.toJson())
          .select();
      return AntropometriModel.fromJson(antropometriData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateAntropometri({
    required String id,
    required double tinggiBadan,
    required double beratBadan,
    required double lingkarPerut,
  }) async {
    try {
      await supabaseClient.from('antropometri').update({
        'tinggi_badan': tinggiBadan,
        'berat_badan': beratBadan,
        'lingkar_perut': lingkarPerut,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', id);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }
}

import 'package:posbinduptm/core/error/exceptions.dart';
import 'package:posbinduptm/features/auth/data/models/user_model.dart';
import 'package:posbinduptm/features/pasien/data/models/pasien_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart'; // Import debugPrint

abstract interface class PasienRemoteDataSource {
  // Dapatkan data pasien berdasarkan profileId
  Future<PasienModel?> getPasienByProfileId({
    required String profileId,
  });

  // Dapatkan data pasien berdasarkan pasienId
  Future<PasienModel?> getPasienByPasienId({
    required String pasienId,
  });

  // Buat data pasien baru
  Future createPasien(PasienModel pasienModel);

  // Update data pasien
  Future updatePasien(PasienModel pasienModel);

  // Update nama profil
  Future<void> updateProfileName({
    required String profileId,
    required String profileName,
  });

  // Dapatkan data user berdasarkan ID
  Future<UserModel?> getUserById(String userId);
}

class PasienRemoteDataSourceImpl implements PasienRemoteDataSource {
  final SupabaseClient supabaseClient;

  PasienRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<PasienModel?> getPasienByProfileId({
    required String profileId,
  }) async {
    try {
      final results = await supabaseClient
          .from('pasien')
          .select('*, profiles(name)')
          .eq('profile_id', profileId)
          .limit(1);

      if (results.isEmpty) {
        return null;
      }

      final data = results.first;
      debugPrint('Data pasien dari Supabase: $data'); // Tambahkan debugPrint
      return PasienModel.fromJson(data);
    } on PostgrestException catch (e) {
      debugPrint('PostgrestException: ${e.message}'); // Tambahkan debugPrint
      throw ServerException(e.message);
    }
  }

  @override
  Future<PasienModel?> getPasienByPasienId({
    required String pasienId,
  }) async {
    try {
      final results = await supabaseClient
          .from('pasien')
          .select('*, profiles(name)')
          .eq('pasien_id', pasienId)
          .limit(1);

      if (results.isEmpty) {
        return null;
      }

      final data = results.first;
      debugPrint('Data pasien dari Supabase: $data'); // Tambahkan debugPrint
      return PasienModel.fromJson(data);
    } on PostgrestException catch (e) {
      debugPrint('PostgrestException: ${e.message}'); // Tambahkan debugPrint
      throw ServerException(e.message);
    }
  }

  @override
  Future createPasien(PasienModel pasienModel) async {
    try {
      await supabaseClient.from('pasien').insert(pasienModel.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future updatePasien(PasienModel pasienModel) async {
    try {
      await supabaseClient
          .from('pasien')
          .update(pasienModel.toJson())
          .eq('pasien_id', pasienModel.pasienId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateProfileName({
    required String profileId,
    required String profileName,
  }) async {
    try {
      await supabaseClient
          .from('profiles')
          .update({'name': profileName}).eq('id', profileId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final SupabaseClient _supabase;
  ProfileRepository(this._supabase);

  Future<Map<String, dynamic>> getProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception("User not logged in");

    final response = await _supabase.from('profiles').select().eq('id', userId).single();
    return response;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}

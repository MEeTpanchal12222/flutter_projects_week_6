import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteRepository {
  final SupabaseClient _supabase;
  FavoriteRepository(this._supabase);

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final userId = _supabase.auth.currentUser?.id;
    final response = await _supabase
        .from('favorites')
        .select('*, products(*)')
        .eq('user_id', userId!);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> toggleFavorite(String productId) async {
    final userId = _supabase.auth.currentUser?.id;
    final exists = await _supabase
        .from('favorites')
        .select()
        .eq('user_id', userId!)
        .eq('product_id', productId)
        .maybeSingle();

    if (exists != null) {
      await _supabase.from('favorites').delete().eq('id', exists['id']);
    } else {
      await _supabase.from('favorites').insert({'user_id': userId, 'product_id': productId});
    }
  }
}

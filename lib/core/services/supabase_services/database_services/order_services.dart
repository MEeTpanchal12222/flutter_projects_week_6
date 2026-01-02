import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository {
  final SupabaseClient _supabase;
  OrderRepository(this._supabase);

  Future<List<Map<String, dynamic>>> getOrders() async {
    final userId = _supabase.auth.currentUser?.id;
    return List<Map<String, dynamic>>.from(
      await _supabase
          .from('orders')
          .select()
          .eq('user_id', userId!)
          .order('created_at', ascending: false),
    );
  }
}

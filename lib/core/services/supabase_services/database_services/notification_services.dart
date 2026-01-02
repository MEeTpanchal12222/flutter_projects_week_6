import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRepository {
  final SupabaseClient _supabase;
  NotificationRepository(this._supabase);

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final userId = _supabase.auth.currentUser?.id;
    return List<Map<String, dynamic>>.from(
      await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId!)
          .order('created_at', ascending: false),
    );
  }
}

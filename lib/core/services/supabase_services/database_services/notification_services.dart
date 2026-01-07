import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../config/env.dart';

class NotificationRepository {
  final SupabaseClient _supabase;
  NotificationRepository(this._supabase);

  Future<void> init() async {
    // 1. Initialize OneSignal
    // Replace with your actual OneSignal App ID
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(Env.oneSignalAppId);

    // 2. Request Permissions
    OneSignal.Notifications.requestPermission(true);

    // 3. Link Supabase User to OneSignal
    // The Edge Function uses "external_id" which we set here as the Supabase UID
    final userId = _supabase.auth.currentUser?.id;
    if (userId != null) {
      OneSignal.login(userId);
      debugPrint("OneSignal: Logged in user $userId");
    }

    // 4. Handle Notification Clicked (Foreground/Background)
    OneSignal.Notifications.addClickListener((event) {
      debugPrint('Notification Clicked: ${event.notification.body}');
      // You can add deep-linking logic here using your GoRouter
    });
  }

  // Call this during Sign Out
  void logout() {
    OneSignal.logout();
  }

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

   /// Mark a specific notification as read
  Future<void> markAsRead(String id) async {
    await _supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', id);
  }
}

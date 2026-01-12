import 'package:flutter/material.dart';
import '../services/supabase_services/database_services/notification_services.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repo;
  NotificationProvider(this._repo);

  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

 
  Future<void> loadNotifications() async {
    isLoading = true;
    notifyListeners();
    try {
      notifications = await _repo.getNotifications();
    } catch (e) {
      debugPrint("Error loading notifications: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> markRead(int index,BuildContext context) async {
    final id = notifications[index]['id'];
    notifications[index]['is_read'] = true;
    notifyListeners();
    try {
      await _repo.markAsRead(id.toString(), context);
    } catch (e) {
      debugPrint("Error marking read: $e");
    }
  }
}

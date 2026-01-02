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
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

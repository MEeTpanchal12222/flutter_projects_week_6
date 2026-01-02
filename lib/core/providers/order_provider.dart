import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/services/supabase_services/database_services/order_services.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repo;
  OrderProvider(this._repo);

  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  Future<void> loadOrders() async {
    isLoading = true;
    notifyListeners();
    try {
      orders = await _repo.getOrders();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

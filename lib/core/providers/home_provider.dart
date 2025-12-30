import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/base_model/product.dart';
import 'package:flutter_projects_week_6/core/services/supabase_services/database_services/product_services.dart';

class HomeProvider extends ChangeNotifier {
  final ProductRepository _repo;
  HomeProvider(this._repo);

  List<Product> products = [];
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();
    try {
      final results = await Future.wait([_repo.getProducts(), _repo.getCategories()]);
      products = results[0] as List<Product>;
      categories = results[1] as List<Map<String, dynamic>>;
    } on Exception catch (e, st) {
      log("Error", name: "Load Data", error: e, stackTrace: st);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

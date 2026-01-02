import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/base_model/product.dart';
import 'package:flutter_projects_week_6/core/base_model/tips.dart';
import 'package:flutter_projects_week_6/core/services/supabase_services/database_services/product_services.dart';

class HomeProvider extends ChangeNotifier {
  final ProductRepository _repo;
  HomeProvider(this._repo);

  List<Product> products = [];
  List<Map<String, dynamic>> categories = [];
  List<Product> popularProducts = [];
  List<Product> newArrivals = [];
  List<Tip> tips = [];
  bool isLoading = true;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();
    try {
      final results = await Future.wait([
        _repo.getProducts(),
        _repo.getCategories(),
        _repo.getPopularProducts(),
        _repo.getNewArrivals(),
        _repo.getTips(),
      ]);
      products = results[0] as List<Product>;
      categories = results[1] as List<Map<String, dynamic>>;
      popularProducts = results[2] as List<Product>;
      newArrivals = results[3] as List<Product>;
      tips = results[4] as List<Tip>;
    } on Exception catch (e, st) {
      log("Error", name: "Load Data", error: e, stackTrace: st);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

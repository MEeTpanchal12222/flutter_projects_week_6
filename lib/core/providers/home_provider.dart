import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/base_model/product.dart';
import 'package:flutter_projects_week_6/core/base_model/tips.dart';
import 'package:flutter_projects_week_6/core/services/supabase_services/database_services/product_services.dart';

class HomeProvider extends ChangeNotifier {
  final ProductRepository _repo;
  HomeProvider(this._repo);

  List<Product> products = [];
  List<Product> filterProduct = [];
  List<Map<String, dynamic>> categories = [];
  List<Product> popularProducts = [];
  List<Product> newArrivals = [];
  List<Tip> tips = [];
  bool isLoading = true;
  int selectedCategoryId = 0;
  StreamSubscription? _productsSubscription;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      final staticData = await Future.wait([
        _repo.getCategories(),
        _repo.getTips(),
        _repo.getPopularProducts(),
        _repo.getNewArrivals(),
      ]);

      categories = staticData[0] as List<Map<String, dynamic>>;
      tips = staticData[1] as List<Tip>;
      popularProducts = staticData[2] as List<Product>;
      newArrivals = staticData[3] as List<Product>;

      _productsSubscription?.cancel();
      _productsSubscription = _repo.getProducts().listen((updatedProducts) {
        products = updatedProducts;
        _applyFilters();
      });
    } catch (e) {
      debugPrint("Error loading Home Data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(int id) {
    selectedCategoryId = id;
    _applyFilters();
  }

  void _applyFilters() {
    filterProduct = List.from(products);
    List<Product> temp = List.from(products);

    if (selectedCategoryId != 0) {
      temp = temp.where((p) => p.categoryId == selectedCategoryId).toList();
    }
    filterProduct = temp;
    notifyListeners();
  }

  Future<void> toggleFavorite(String productId) async {
    try {
      await _repo.toggleLike(productId);
    } catch (e) {
      debugPrint("Error toggling like: $e");
    }
  }
}

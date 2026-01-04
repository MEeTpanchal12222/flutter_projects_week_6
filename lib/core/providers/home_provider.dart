import 'dart:async';
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
  int selectedCategoryId = 0;
  StreamSubscription? _favSubscription;

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
      _initRealtimeFavorites();
      _applyFilters();
    } on Exception catch (e, st) {
      log("Error", name: "Load Data", error: e, stackTrace: st);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _initRealtimeFavorites() {
    _favSubscription?.cancel();
    _favSubscription = _repo.getFavoritesStream().listen((likedIds) {
      _updateListsWithRealtimeData(likedIds);
    });
  }

    void _updateListsWithRealtimeData(Set<String> likedIds) {
    // Helper to update a list of products based on the set of liked IDs
    List<Product> updateList(List<Product> list) {
      return list.map((p) {
        final isLiked = likedIds.contains(p.id);
        // Only update if changed to avoid unnecessary object creation
        if (p.isFavorite != isLiked) {
          return p.copyWith(
            p.id,
            p.name,
            p.description,
            p.price,
            p.imageUrl,
            p.rating,
            p.categoryId,
            isLiked,
          );
        }
        return p;
      }).toList();
    }

    products = updateList(products);
    popularProducts = updateList(popularProducts);
    newArrivals = updateList(newArrivals);

   
    _applyFilters();
  }

  void selectCategory(int id) {
    selectedCategoryId = id;
    _applyFilters();
  }

  void _applyFilters() {
    List<Product> temp = List.from(products);

    if (selectedCategoryId != 0) {
      temp = temp.where((p) => p.categoryId == selectedCategoryId).toList();
    }

    products = temp;
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

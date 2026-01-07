import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/base_model/product.dart';

import '../services/supabase_services/database_services/favorites_services.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteRepository _repo;
  FavoriteProvider(this._repo);

  List<Product> favorites = [];
  bool isLoading = true;
  StreamSubscription? _subscription;

  void loadFavorites() {
    isLoading = true;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _repo.getFavoriteProductsStream().listen(
      (data) {
        favorites = data;
        isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        debugPrint("Favorite Stream Error: $error");
        isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> toggleFavorite(String productId) async {
    try {
      await _repo.toggleFavorite(productId);
    } catch (e) {
      debugPrint("Toggle Error: $e");
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

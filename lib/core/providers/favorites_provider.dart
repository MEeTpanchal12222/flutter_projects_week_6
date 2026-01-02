import 'package:flutter/material.dart';

import '../services/supabase_services/database_services/favorites_services.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteRepository _repo;
  FavoriteProvider(this._repo);

  List<Map<String, dynamic>> favorites = [];
  bool isLoading = true;

  Future<void> loadFavorites() async {
    isLoading = true;
    notifyListeners();
    try {
      favorites = await _repo.getFavorites();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String productId) async {
    await _repo.toggleFavorite(productId);
    await loadFavorites(); // Refresh list
  }
}

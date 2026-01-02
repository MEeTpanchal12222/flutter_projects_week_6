import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/base_model/product.dart';

import '../services/supabase_services/database_services/product_services.dart';

class SearchProvider extends ChangeNotifier {
  final ProductRepository _repo;
  SearchProvider(this._repo);

  List<Product> searchResults = [];
  bool isLoading = false;
  Timer? _debounce;
  final searchCtrl = TextEditingController();

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.isEmpty) {
      searchResults = [];
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        searchResults = await _repo.searchProducts(query);
      } catch (e) {
        debugPrint("Search error: $e");
      } finally {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

import '../base_model/product.dart';
import '../base_model/review.dart';
import '../services/supabase_services/database_services/product_services.dart';

class PlantDetailProvider extends ChangeNotifier {
  final ProductRepository _repo;
  PlantDetailProvider(this._repo);

  Product? product;
  List<Review> reviews = [];
  List<Product> similarPlants = [];

  bool isLoadingProduct = false;
  bool isLoadingReviews = false;
  bool isLoadingSimilar = false;
  bool hasMoreReviews = true;

  int _currentReviewPage = 0;
  final int _pageSize = 5;
  StreamSubscription<Product?>? _productSubscription;

  void subscribeToProduct(String productId) {
    isLoadingProduct = true;
    notifyListeners();

    _productSubscription?.cancel();
    _productSubscription = _repo
        .getProductById(productId: productId)
        .listen(
          (updatedProduct) {
            product = updatedProduct;
            isLoadingProduct = false;

            if (product != null && similarPlants.isEmpty && !isLoadingSimilar) {
              fetchSimilarPlants(productId, product!.categoryId ?? 1);
            }

            notifyListeners();
          },
          onError: (error) {
            debugPrint("Error in product stream: $error");
            isLoadingProduct = false;
            notifyListeners();
          },
        );
  }

  Future<void> fetchReviews(String plantId, {bool isRefresh = false}) async {
    if (isRefresh) {
      _currentReviewPage = 0;
      reviews = [];
      hasMoreReviews = true;
    }

    if (!hasMoreReviews || isLoadingReviews) return;

    isLoadingReviews = true;
    notifyListeners();

    try {
      final fetched = await _repo.getPlantReviews(plantId: plantId, page: _currentReviewPage);

      if (fetched.length < _pageSize) {
        hasMoreReviews = false;
      }

      reviews.addAll(fetched);
      _currentReviewPage++;
    } catch (e) {
      debugPrint("Error fetching reviews: $e");
    } finally {
      isLoadingReviews = false;
      notifyListeners();
    }
  }

  Future<void> fetchSimilarPlants(String plantId, int categoryId) async {
    isLoadingSimilar = true;
    notifyListeners();

    try {
      similarPlants = await _repo.getSimilarPlants(
        plantId: plantId,
        categoryId: categoryId,
        limit: 10,
        offset: 0,
      );
    } catch (e) {
      debugPrint("Error fetching similar plants: $e");
    } finally {
      isLoadingSimilar = false;
      notifyListeners();
    }
  }

  void clear() {
    _productSubscription?.cancel();
    product = null;
    reviews = [];
    similarPlants = [];
    _currentReviewPage = 0;
    hasMoreReviews = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _productSubscription?.cancel();
    super.dispose();
  }
}

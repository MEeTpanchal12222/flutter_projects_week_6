import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/base_model/cartItem.dart';
import 'package:flutter_projects_week_6/core/services/supabase_services/database_services/cart_services.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repo;
  CartProvider(this._repo);

  List<CartItem> _items = [];
  bool isLoading = false;

  List<CartItem> get items => _items;

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  Future<void> loadCart() async {
    isLoading = true;
    notifyListeners();
    try {
      _items = await _repo.getCart();
    } catch (e) {
      debugPrint("Error loading cart: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(String productId) async {
    try {
      await _repo.addToCart(productId);
      await loadCart();
    } catch (e) {
      debugPrint("Error adding to cart: $e");
    }
  }

  Future<void> updateQuantity(String itemId, int newQuantity) async {
    try {
      final index = _items.indexWhere((i) => i.id == itemId);
      if (index != -1) {
        if (newQuantity <= 0) {
          _items.removeAt(index);
        } else {
          _items[index].quantity = newQuantity;
        }
        notifyListeners();
      }

      await _repo.updateQuantity(itemId, newQuantity);
      if (newQuantity <= 0) loadCart();
    } catch (e) {
      loadCart();
    }
  }

  Future<void> checkout() async {
    isLoading = true;
    notifyListeners();
    try {
      await _repo.checkout(totalAmount);
      _items.clear();
    } catch (e) {
      debugPrint("Checkout error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

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

  Future<void> loadCart({bool? isload = true}) async {
    isLoading = isload ?? true;
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

  Future<void> addToCart(String productId, BuildContext context) async {
    try {
      await _repo.addToCart(productId, context);
      await loadCart();
    } catch (e) {
      debugPrint("Error adding to cart: $e");
    }
  }

  Future<void> updateQuantity(String itemId, int newQuantity, BuildContext context) async {
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

      await _repo.updateQuantity(itemId, newQuantity, context);
      if (newQuantity <= 0) loadCart(isload: false);
    } catch (e) {
      loadCart();
    }
  }

  Future<void> checkout(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      await _repo.checkout(totalAmount, context);
      _items.clear();
    } catch (e) {
      debugPrint("Checkout error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

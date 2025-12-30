
import 'package:flutter_projects_week_6/core/base_model/product.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    // Expects a join with 'products' table
    final productMap = map['products'] as Map<String, dynamic>;
    return CartItem(
      id: map['id'],
      quantity: map['quantity'],
      product: Product.fromMap(productMap),
    );
  }
}
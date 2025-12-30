import 'package:flutter_projects_week_6/core/base_model/cartItem.dart';
import 'package:flutter_projects_week_6/core/constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartRepository {
  final SupabaseClient _supabase;
  CartRepository(this._supabase);

  Future<List<CartItem>> getCart() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from(AppConstants.cartTable)
        .select('*, products(*)')
        .eq('user_id', userId)
        .order('created_at');

    return (response as List).map((e) => CartItem.fromMap(e)).toList();
  }

  Future<void> addToCart(String productId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    // Check if item exists to increment quantity
    final existing = await _supabase
        .from(AppConstants.cartTable)
        .select()
        .eq('user_id', userId)
        .eq('product_id', productId)
        .maybeSingle();

    if (existing != null) {
      await _supabase
          .from(AppConstants.cartTable)
          .update({'quantity': existing['quantity'] + 1})
          .eq('id', existing['id']);
    } else {
      await _supabase.from(AppConstants.cartTable).insert({
        'user_id': userId,
        'product_id': productId,
        'quantity': 1,
      });
    }
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      await _supabase.from(AppConstants.cartTable).delete().eq('id', itemId);
    } else {
      await _supabase.from(AppConstants.cartTable).update({'quantity': quantity}).eq('id', itemId);
    }
  }

  Future<void> checkout(double totalAmount) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    // 1. Create Order
    final order = await _supabase
        .from(AppConstants.ordersTable)
        .insert({
          'user_id': userId,
          'total_amount': totalAmount,
          'status': 'pending',
          'delivery_address': '123 Green St, Flutter City', // Mock address
          // Add tracking coordinates for the map feature
          'tracking_lat': 37.7749,
          'tracking_lng': -122.4194,
        })
        .select()
        .single();

    // 2. Clear Cart (In a real app, you'd move items to order_items)
    await _supabase.from(AppConstants.cartTable).delete().eq('user_id', userId);
  }
}

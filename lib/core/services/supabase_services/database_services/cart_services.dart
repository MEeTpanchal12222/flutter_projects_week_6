import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/base_model/cartItem.dart';
import 'package:flutter_projects_week_6/core/constant.dart';
import 'package:flutter_projects_week_6/utils/widgets/common_top_notification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartRepository {
  final SupabaseClient _supabase;
  CartRepository(this._supabase);

  Future<List<CartItem>> getCart() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _supabase
          .from(AppConstants.cartTable)
          .select('*, products(*)')
          .eq('user_id', userId)
          .order('created_at');

      return (response as List).map((e) => CartItem.fromMap(e)).toList();
    } catch (e, st) {
      log("Error fetching cart", error: e, stackTrace: st);
      return [];
    }
  }

  Future<void> addToCart(String productId, BuildContext context) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      if (context.mounted) {
        showTopNotification(
          context,
          "Please log in to add items to cart",
          isError: true,
        );
      }
      return;
    }

    try {
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
      if (context.mounted) {
        showTopNotification(context, "Added to cart", isError: false);
      }
    } catch (e, st) {
      log("Error adding to cart", error: e, stackTrace: st);
      if (context.mounted) {
        showTopNotification(
          context,
          "Could not add to cart. Please try again.",
          isError: true,
        );
      }
    }
  }

  Future<void> updateQuantity(
    String itemId,
    int quantity,
    BuildContext context,
  ) async {
    try {
      if (quantity <= 0) {
        await _supabase.from(AppConstants.cartTable).delete().eq('id', itemId);
      } else {
        await _supabase
            .from(AppConstants.cartTable)
            .update({'quantity': quantity})
            .eq('id', itemId);
      }
    } catch (e, st) {
      log("Error updating cart quantity", error: e, stackTrace: st);
      if (context.mounted) {
        showTopNotification(
          context,
          "Failed to update quantity.",
          isError: true,
        );
      }
    }
  }

  Future<void> checkout(double totalAmount, BuildContext context) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final order = await _supabase
          .from(AppConstants.ordersTable)
          .insert({
            'user_id': userId,
            'total_amount': totalAmount,
            'status': 'pending',
            'delivery_address': '123 Green St, Flutter City',

            'tracking_lat': 37.7749,
            'tracking_lng': -122.4194,
          })
          .select()
          .single();

      await _supabase
          .from(AppConstants.cartTable)
          .delete()
          .eq('user_id', userId);

      if (context.mounted) {
        showTopNotification(
          context,
          "Order placed successfully!",
          isError: false,
        );
      }
    } catch (e, st) {
      log("Error during checkout", error: e, stackTrace: st);
      if (context.mounted) {
        showTopNotification(
          context,
          "Checkout failed. Please try again.",
          isError: true,
        );
      }
    }
  }
}

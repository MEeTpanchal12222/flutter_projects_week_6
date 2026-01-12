import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/base_model/product.dart';
import 'package:flutter_projects_week_6/core/constant.dart';
import 'package:flutter_projects_week_6/utils/widgets/common_top_notification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteRepository {
  final SupabaseClient _supabase;
  FavoriteRepository(this._supabase);

  Stream<List<Product>> getFavoriteProductsStream() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return Stream.value([]);

    return _supabase
        .from('favorites')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .asyncMap((favRows) async {
          try {
            if (favRows.isEmpty) return [];

            final likedIds = favRows
                .map((f) => f['product_id'] as String)
                .toList();

            final productRows = await _supabase
                .from(AppConstants.productsTable)
                .select()
                .filter('id', 'in', likedIds);

            return (productRows as List).map((map) {
              return Product.fromMap(map).copyWith(isFavorite: true);
            }).toList();
          } catch (e, st) {
            log("Error mapping favorites stream", error: e, stackTrace: st);
            return [];
          }
        });
  }

  Future<void> toggleFavorite(String productId, BuildContext context) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    try {
      final exists = await _supabase
          .from('favorites')
          .select()
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      if (exists != null) {
        await _supabase.from('favorites').delete().eq('id', exists['id']);
        if (context.mounted) {
          showTopNotification(
            context,
            "Removed from favorites",
            isError: false,
          );
        }
      } else {
        await _supabase.from('favorites').insert({
          'user_id': userId,
          'product_id': productId,
        });
        if (context.mounted) {
          showTopNotification(context, "Added to favorites", isError: false);
        }
      }
    } catch (e, st) {
      log("Error toggling favorite", error: e, stackTrace: st);
      if (context.mounted) {
        showTopNotification(
          context,
          "Failed to update favorites",
          isError: true,
        );
      }
    }
  }
}

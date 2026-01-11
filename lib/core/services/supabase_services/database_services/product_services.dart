import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/base_model/product.dart';
import 'package:flutter_projects_week_6/core/base_model/tips.dart';
import 'package:flutter_projects_week_6/core/constant.dart';
import 'package:flutter_projects_week_6/utils/widgets/common_top_notification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../base_model/review.dart';

class ProductRepository {
  final SupabaseClient _supabase;
  ProductRepository(this._supabase);

  Stream<List<Product>> getProducts() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return Stream.value([]);
    return _supabase
        .from('favorites')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .asyncMap((favRows) async {
          try {
            final productRows = await _supabase
                .from(AppConstants.productsTable)
                .select();

            final likedIds = favRows
                .map((f) => f['product_id'] as String)
                .toSet();

            return (productRows as List).map((map) {
              final isLiked = likedIds.contains(map['id']);

              final product = Product.fromMap(map);

              return product.copyWith(isFavorite: isLiked);
            }).toList();
          } catch (e, st) {
            log("Error mapping products stream", error: e, stackTrace: st);
            return [];
          }
        });
  }

  Stream<Product?> getProductById({required String productId}) {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return Stream.value(null);
    return _supabase
        .from('favorites')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .asyncMap((favRows) async {
          try {
            final productData = await _supabase
                .from(AppConstants.productsTable)
                .select()
                .eq('id', productId)
                .maybeSingle();

            if (productData == null) return null;

            final isLiked = favRows.any((f) => f['product_id'] == productId);

            return Product.fromMap(productData).copyWith(isFavorite: isLiked);
          } catch (e, st) {
            log("Error mapping products stream", error: e, stackTrace: st);
            return null;
          }
        });
  }

  Future<List<Review>> getPlantReviews({
    required String plantId,
    required int page,
    int pageSize = 5,
  }) async {
    final from = page * pageSize;
    final to = from + pageSize - 1;

    try {
      final response = await _supabase
          .from('reviews')
          .select('*, profiles!user_id(full_name, avatar_url)')
          .eq('product_id', plantId)
          .order('created_at', ascending: false)
          .range(from, to);

      return (response as List).map((e) => Review.fromMap(e)).toList();
    } catch (e, st) {
      log("Error fetching reviews", error: e, stackTrace: st);

      final fallbackResponse = await _supabase
          .from('reviews')
          .select('*')
          .eq('product_id', plantId)
          .order('created_at', ascending: false)
          .range(from, to);

      return (fallbackResponse as List).map((e) => Review.fromMap(e)).toList();
    }
  }

  Future<void> addReview({
    required String productId,
    required int rating,
    required String comment,
    required BuildContext context,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      if (context.mounted) {
        showTopNotification(
          context,
          "You must be logged in to review",
          isError: true,
        );
      }
      // Depending on logic, we might still throw or just return.
      // throw Exception("You must be logged in to review");
      return;
    }
    try {
      await _supabase.from('reviews').insert({
        'product_id': productId,
        'user_id': userId,
        'rating': rating,
        'comment': comment,
      });
      if (context.mounted) {
        showTopNotification(
          context,
          "Review added successfully",
          isError: false,
        );
      }
    } catch (e, st) {
      log("Error adding review", error: e, stackTrace: st);
      if (context.mounted) {
        showTopNotification(context, "Failed to add review", isError: true);
      }
    }
  }

  Future<List<Product>> getSimilarPlants({
    required String plantId,
    required int categoryId,
    int limit = 10,
    int offset = 0,
  }) async {
    final response = await _supabase.rpc(
      'get_similar_plants',
      params: {
        'p_plant_id': plantId,
        'p_category_id': categoryId,
        'p_limit': limit,
        'p_offset': offset,
      },
    );

    return (response as List).map((e) => Product.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      return List<Map<String, dynamic>>.from(
        await _supabase.from(AppConstants.categoriesTable).select(),
      );
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
      return [];
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) return [];

    final response = await _supabase
        .from(AppConstants.productsTable)
        .select()
        .ilike('name', '%$query%');

    return (response as List).map((e) => Product.fromMap(e)).toList();
  }

  Future<List<Product>> getPopularProducts() async {
    final response = await _supabase
        .from('products')
        .select()
        .eq('is_featured', true)
        .limit(5);
    return (response as List).map((e) => Product.fromMap(e)).toList();
  }

  Future<List<Product>> getNewArrivals() async {
    final response = await _supabase
        .from('products')
        .select()
        .order('created_at', ascending: false)
        .limit(5);
    return (response as List).map((e) => Product.fromMap(e)).toList();
  }

  Future<List<Tip>> getTips() async {
    final response = await _supabase.from('tips').select();
    return (response as List).map((e) => Tip.fromMap(e)).toList();
  }

  Stream<Set<String>> getFavoritesStream() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return Stream.value({});

    return _supabase
        .from('favorites')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) => data.map((e) => e['product_id'] as String).toSet());
  }

  Future<void> toggleLike(String productId, BuildContext context) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final existing = await _supabase
          .from('favorites')
          .select()
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      if (existing != null) {
        try {
          await _supabase
              .from('favorites')
              .delete()
              .eq('id', existing['id'])
              .eq('user_id', userId)
              .eq('product_id', productId);

          if (context.mounted) {
            showTopNotification(
              context,
              "Removed from Favorites",
              isError: false,
            );
          }
        } on Error catch (Error) {
          log(Error.toString());
        }
      } else {
        try {
          await _supabase.from('favorites').insert({
            'user_id': userId,
            'product_id': productId,
          });
          if (context.mounted) {
            showTopNotification(context, "Added to Favorites", isError: false);
          }
        } on PostgrestException catch (e) {
          if (e.code == '23505') {
            await _supabase
                .from('favorites')
                .delete()
                .eq('user_id', userId)
                .eq('product_id', productId);
            // Also notify here? Maybe removed?
            if (context.mounted) {
              showTopNotification(
                context,
                "Removed from Favorites",
                isError: false,
              );
            }
          } else {
            rethrow;
          }
        }
      }
    } catch (e, st) {
      log("Error toggling like", error: e, stackTrace: st);
      if (context.mounted) {
        showTopNotification(context, "An error occurred", isError: true);
      }
      // rethrow; // We handled it with notification
    }
  }
}

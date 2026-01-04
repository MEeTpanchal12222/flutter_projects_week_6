import 'dart:developer';

import 'package:flutter_projects_week_6/core/base_model/product.dart';
import 'package:flutter_projects_week_6/core/base_model/tips.dart';
import 'package:flutter_projects_week_6/core/constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository {
  final SupabaseClient _supabase;
  ProductRepository(this._supabase);

  Future<List<Product>> getProducts() async {
    try {
      final response = await _supabase.from(AppConstants.productsTable).select(
        '''
        *,
        favorites!left(id)
      ''',
      );
      return (response as List).map((e) => Product.fromMap(e)).toList();
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
      return [];
    }
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
        .stream(primaryKey: ['id']) // Listen to changes
        .eq('user_id', userId) // Only my favorites
        .map((data) => data.map((e) => e['product_id'] as String).toSet());
  }

  Future<void> toggleLike(String productId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final exists = await _supabase
          .from('favorites')
          .select()
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      if (exists != null) {
        await _supabase.from('favorites').delete().eq('id', exists['id']);
      } else {
        await _supabase.from('favorites').insert({
          'user_id': userId,
          'product_id': productId,
        });
      }
    } catch (e, st) {
      log("Error toggling like: $e", stackTrace: st);
    }
  }

}

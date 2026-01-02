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
      final response = await _supabase.from(AppConstants.productsTable).select();
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
    final response = await _supabase.from('products').select().eq('is_featured', true).limit(5);
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
}

import 'dart:developer';

import 'package:flutter_projects_week_6/core/base_model/product.dart';
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
}

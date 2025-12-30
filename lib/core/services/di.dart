import 'package:flutter_projects_week_6/core/providers/auth_provider.dart';
import 'package:flutter_projects_week_6/core/providers/cart_provider.dart';
import 'package:flutter_projects_week_6/core/providers/home_provider.dart';
import 'package:flutter_projects_week_6/core/services/supabase_services/auth_services/auth_services.dart';
import 'package:flutter_projects_week_6/core/services/supabase_services/database_services/cart_services.dart';
import 'package:flutter_projects_week_6/core/services/supabase_services/database_services/product_services.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);

    // 2. Repositories (Data Layer)
    getIt.registerLazySingleton(() => AuthRepository(getIt()));
    getIt.registerLazySingleton(() => ProductRepository(getIt()));
    getIt.registerLazySingleton(() => CartRepository(getIt()));

    // 3. Providers (State Layer)
    getIt.registerFactory(() => AuthProvider(getIt()));
    getIt.registerFactory(() => HomeProvider(getIt()));

    // Cart is a Singleton because we want the cart state to persist
    // as the user navigates between screens (Home -> Details -> Cart)
    getIt.registerLazySingleton(() => CartProvider(getIt<CartRepository>()));
  }
}

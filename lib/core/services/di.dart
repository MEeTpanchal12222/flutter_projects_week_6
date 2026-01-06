import 'package:flutter_projects_week_6/core/providers/add_plant_provider.dart';
import 'package:flutter_projects_week_6/core/providers/auth_provider.dart';
import 'package:flutter_projects_week_6/core/providers/cart_provider.dart';
import 'package:flutter_projects_week_6/core/providers/home_provider.dart';
import 'package:flutter_projects_week_6/core/providers/notification_provider.dart';
import 'package:flutter_projects_week_6/core/providers/search_provider.dart';
import 'package:flutter_projects_week_6/core/services/supabase_services/auth_services/auth_services.dart';
import 'package:flutter_projects_week_6/core/services/supabase_services/database_services/cart_services.dart';
import 'package:flutter_projects_week_6/core/services/supabase_services/database_services/product_services.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/favorites_provider.dart';
import '../providers/order_provider.dart';
import '../providers/product_details_provider.dart';
import '../providers/profile_provider.dart';
import 'supabase_services/database_services/favorites_services.dart';
import 'supabase_services/database_services/notification_services.dart';
import 'supabase_services/database_services/order_services.dart';
import 'supabase_services/database_services/profile_services.dart';

final getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);

    getIt.registerLazySingleton(() => AuthRepository(getIt()));
    getIt.registerLazySingleton(() => ProductRepository(getIt()));
    getIt.registerLazySingleton(() => CartRepository(getIt()));
    getIt.registerLazySingleton(() => ProfileRepository(getIt()));
    getIt.registerLazySingleton(() => OrderRepository(getIt()));
    getIt.registerLazySingleton(() => FavoriteRepository(getIt()));
    getIt.registerLazySingleton(() => NotificationRepository(getIt()));

    getIt.registerFactory(() => AuthProvider(getIt()));
    getIt.registerFactory(() => HomeProvider(getIt()));
    getIt.registerFactory(() => ProfileProvider(getIt()));
    getIt.registerFactory(() => OrderProvider(getIt()));
    getIt.registerFactory(() => FavoriteProvider(getIt()));
    getIt.registerFactory(() => NotificationProvider(getIt()));
    getIt.registerFactory(() => SearchProvider(getIt()));
    getIt.registerFactory(() => AddPlantProvider(getIt()));
    getIt.registerFactory(() => PlantDetailProvider(getIt()));

    // Cart is a Singleton because we want the cart state to persist
    // as the user navigates between screens (Home -> Details -> Cart)
    getIt.registerLazySingleton(() => CartProvider(getIt<CartRepository>()));
  }
}

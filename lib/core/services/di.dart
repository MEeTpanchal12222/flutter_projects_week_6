import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    await Supabase.initialize(url: 'YOUR_SUPABASE_URL', anonKey: 'YOUR_SUPABASE_ANON_KEY');

    getIt.registerLazySingleton(() => Supabase.instance.client);
  }
}

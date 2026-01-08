import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/config/env.dart';
import 'package:flutter_projects_week_6/core/router/app_router.dart';
import 'package:flutter_projects_week_6/core/services/di.dart';
import 'package:flutter_projects_week_6/core/services/supabase_services/database_services/notification_services.dart';
import 'package:flutter_projects_week_6/firebase_options.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(Env.oneSignalAppId);
  OneSignal.Notifications.requestPermission(true);
  await DependencyInjection.init();
  getIt<NotificationRepository>().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(debugShowCheckedModeBanner: false, routerConfig: router);
  }
}

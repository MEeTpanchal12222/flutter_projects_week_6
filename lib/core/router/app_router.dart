import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/module/Home/home_screen.dart';
import 'package:flutter_projects_week_6/module/Login/login_screen.dart';
import 'package:flutter_projects_week_6/module/Plant/product_screen.dart';
import 'package:flutter_projects_week_6/module/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'app_router.g.dart';

@TypedGoRoute<SplashRoute>(path: '/')
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashScreen();
  }
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginScreen();
}

@TypedGoRoute<HomeRoute>(
  path: "/home",
  routes: [
    TypedGoRoute<PlantRoute>(path: 'plant/:plantId'),
    TypedGoRoute<PlantMapRoute>(path: 'map/:plantId'),
  ],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

class PlantRoute extends GoRouteData with $PlantRoute {
  final String plantId;
  PlantRoute({required this.plantId});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProductScreen(productId: plantId);
  }
}

class PlantMapRoute extends GoRouteData with $PlantMapRoute {
  final String plantId;
  PlantMapRoute({required this.plantId});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProductScreen(productId: plantId);
  }
}

final router = GoRouter(
  routes: $appRoutes,
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(Supabase.instance.client.auth.onAuthStateChange),
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final loc = state.matchedLocation;

    if (loc == '/') return session != null ? '/home' : null;
    if (session == null && loc != '/login') return '/login';
    if (session != null && loc == '/login') return '/home';

    return null;
  },
);

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((dynamic _) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

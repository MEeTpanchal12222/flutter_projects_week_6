import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/module/AddPlant/screens/add_plant_screen.dart';
import 'package:flutter_projects_week_6/module/Home/screens/home_screen.dart';
import 'package:flutter_projects_week_6/module/Notification/screens/notification_screen.dart';
import 'package:flutter_projects_week_6/module/Product/screens/product_screen.dart';
import 'package:flutter_projects_week_6/module/auth/signin/screens/signin_screen.dart';
import 'package:flutter_projects_week_6/module/auth/signup/screens/signup_screen.dart';
import 'package:flutter_projects_week_6/module/cart/screens/cart_screen.dart';
import 'package:flutter_projects_week_6/module/favorite/screens/favorites_screen.dart';
import 'package:flutter_projects_week_6/module/order/screens/order_screen.dart';
import 'package:flutter_projects_week_6/module/profile/screens/profile_screen.dart';
import 'package:flutter_projects_week_6/module/search/screens/search_screen.dart';
import 'package:flutter_projects_week_6/module/splash/screens/splash_screen.dart';
import 'package:flutter_projects_week_6/module/tracking/screens/tracking_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../module/main/main_shell.dart';

part 'app_router.g.dart';

@TypedGoRoute<SplashRoute>(path: '/')
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashScreen();
  }
}

@TypedGoRoute<SigninRoute>(path: '/signin')
class SigninRoute extends GoRouteData with $SigninRoute {
  const SigninRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => SignInScreen();
}

@TypedGoRoute<SignupRoute>(path: '/signup')
class SignupRoute extends GoRouteData with $SignupRoute {
  const SignupRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => SignUpScreen();
}

@TypedStatefulShellRoute<MainShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<HomeBranchData>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<HomeRoute>(path: '/home')],
    ),

    TypedStatefulShellBranch<FavoriteBranchData>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<FavoritesRoute>(path: '/fav')],
    ),

    TypedStatefulShellBranch<CartBranchData>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<CartRoute>(path: '/cart')],
    ),

    TypedStatefulShellBranch<ProfileBranchData>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<ProfileRoute>(path: '/profile')],
    ),
  ],
)
class MainShellRouteData extends StatefulShellRouteData {
  const MainShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MainShell(navigationShell: navigationShell);
  }
}

class HomeBranchData extends StatefulShellBranchData {
  const HomeBranchData();
}

class FavoriteBranchData extends StatefulShellBranchData {
  const FavoriteBranchData();
}

class CartBranchData extends StatefulShellBranchData {
  const CartBranchData();
}

class ProfileBranchData extends StatefulShellBranchData {
  const ProfileBranchData();
}

class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return HomeScreen();
  }
}

@TypedGoRoute<PlantRoute>(path: '/plant/:plantId')
class PlantRoute extends GoRouteData with $PlantRoute {
  final String plantId;
  PlantRoute({required this.plantId});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProductScreen(key: ValueKey(plantId), productId: plantId);
  }
}

@TypedGoRoute<TrackingRoute>(path: '/tracking')
class TrackingRoute extends GoRouteData with $TrackingRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TrackingScreen();
  }
}

@TypedGoRoute<CartRoute>(path: '/cart')
class CartRoute extends GoRouteData with $CartRoute {
  const CartRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CartScreen();
  }
}

class FavoritesRoute extends GoRouteData with $FavoritesRoute {
  const FavoritesRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FavoriteScreen();
  }
}

class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProfileScreen();
  }
}

@TypedGoRoute<SearchRoute>(path: '/search')
class SearchRoute extends GoRouteData with $SearchRoute {
  const SearchRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SearchScreen();
  }
}

@TypedGoRoute<OrderRoute>(path: '/order')
class OrderRoute extends GoRouteData with $OrderRoute {
  const OrderRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return OrderScreen();
  }
}

@TypedGoRoute<NotificationRoute>(path: '/notification')
class NotificationRoute extends GoRouteData with $NotificationRoute {
  const NotificationRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NotificationScreen();
  }
}

@TypedGoRoute<AddPlantRoute>(path: '/addPlant')
class AddPlantRoute extends GoRouteData with $AddPlantRoute {
  const AddPlantRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AddPlantScreen();
  }
}

final router = GoRouter(
  routes: $appRoutes,
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(Supabase.instance.client.auth.onAuthStateChange),
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final loc = state.matchedLocation;

    if (session != null) {
      if (loc == '/' || loc == '/signin' || loc == '/signup') {
        return '/home';
      }
    }
    if (session == null) {
      if (loc == '/' || loc == '/signin' || loc == '/signup') {
        return null;
      }
      return '/';
    }

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

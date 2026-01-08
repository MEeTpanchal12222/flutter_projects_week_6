import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/theme/app_theme.dart';

class MainShell extends StatelessWidget {
  const MainShell({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('MainShell'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    int currentIndex = navigationShell.currentIndex;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        surfaceTintColor: AppTheme.primary,
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(index);
          currentIndex = index;
        },
        labelTextStyle: WidgetStateTextStyle.resolveWith(
          (states) => GoogleFonts.cabin(
            fontWeight: FontWeight.bold,
            color: states.contains(WidgetState.selected) ? AppTheme.textMain : Colors.grey,
          ),
        ),
        indicatorColor: AppTheme.secondary,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: AppTheme.primary, width: 1),
        ),

        backgroundColor: AppTheme.backgroundLight,
        animationDuration: const Duration(milliseconds: 1000),

        shadowColor: Colors.transparent,
        height: 70,

        elevation: 0,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Favorite'),
          NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

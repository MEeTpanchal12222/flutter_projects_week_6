import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/providers/profile_provider.dart';
import 'package:flutter_projects_week_6/core/router/app_router.dart';
import 'package:flutter_projects_week_6/core/services/di.dart';
import 'package:flutter_projects_week_6/utils/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widgets/logout_widget.dart';
import '../widgets/profile_opation.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<ProfileProvider>()..loadProfile(),
      child: const _ProfileContent(),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.cabin(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: AppTheme.primary.withValues(alpha: 0.4),
        elevation: 0,
      ),
      body: provider.isLoading
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: AppTheme.backgroundLight,
              child: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      provider.profile?['avatar_url'] ??
                          "https://ui-avatars.com/api/?name=${provider.profile?['full_name']}",
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.profile?['full_name'] ?? "User",
                    style: GoogleFonts.cabin(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    provider.profile?['email'] ?? "",
                    style: GoogleFonts.cabin(color: Colors.grey),
                  ),

                  const SizedBox(height: 40),

                  ProfileOption(
                    icon: Icons.shopping_bag_outlined,
                    title: "My Orders",
                    onTap: () => OrderRoute().push(context),
                  ),
                  ProfileOption(
                    icon: Icons.favorite_border,
                    title: "Wishlist",
                    onTap: () => FavoritesRoute().push(context),
                  ),
                  ProfileOption(
                    icon: Icons.notifications_none,
                    title: "Notifications",
                    onTap: () => NotificationRoute().push(context),
                  ),
                  ProfileOption(
                    image: 'Assets/potted-plant.png',
                    title: "Add Plant",
                    onTap: () => AddPlantRoute().push(context),
                  ),
                  const Spacer(),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.logout, color: Colors.red),
                    ),
                    title: const Text(
                      "Log Out",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      showLogoutDialog(context, provider);
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

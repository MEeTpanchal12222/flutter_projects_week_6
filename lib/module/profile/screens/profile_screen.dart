import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/providers/profile_provider.dart';
import 'package:flutter_projects_week_6/core/router/app_router.dart';
import 'package:flutter_projects_week_6/core/services/di.dart';
import 'package:flutter_projects_week_6/utils/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
          ? const Center(child: CircularProgressIndicator())
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

                  _ProfileOption(
                    icon: Icons.shopping_bag_outlined,
                    title: "My Orders",
                    onTap: () => OrderRoute().push(context),
                  ),
                  _ProfileOption(
                    icon: Icons.favorite_border,
                    title: "Wishlist",
                    onTap: () => FavoritesRoute().push(context),
                  ),
                  _ProfileOption(
                    icon: Icons.notifications_none,
                    title: "Notifications",
                    onTap: () => NotificationRoute().push(context),
                  ),
                  _ProfileOption(
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
                      _showLogoutDialog(context, provider);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(
          "Log Out",
          style: GoogleFonts.cabin(color: AppTheme.textMain, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to log out?",
          style: GoogleFonts.cabin(color: AppTheme.textMain),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: Text(
              "Cancel",
              style: GoogleFonts.cabin(color: AppTheme.primary, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () async {
              ctx.pop();
              await provider.signOut();
              if (context.mounted) context.go('/');
            },
            child: Text(
              "Log Out",
              style: GoogleFonts.cabin(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData? icon;
  final String title;
  final VoidCallback onTap;
  final String? image;

  const _ProfileOption({this.icon, required this.title, required this.onTap, this.image});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
        child: (icon != null && image == null)
            ? Icon(icon, color: AppTheme.primary)
            : ImageIcon(AssetImage(image!), color: AppTheme.primary),
      ),
      title: Text(title, style: GoogleFonts.cabin(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}

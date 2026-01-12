import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/theme/app_theme.dart';

class ProfileOption extends StatelessWidget {
  final IconData? icon;
  final String title;
  final VoidCallback onTap;
  final String? image;

  const ProfileOption({super.key, this.icon, required this.title, required this.onTap, this.image});

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

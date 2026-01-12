import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/providers/profile_provider.dart';
import '../../../utils/theme/app_theme.dart';

void showLogoutDialog(BuildContext context, ProfileProvider provider) {
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

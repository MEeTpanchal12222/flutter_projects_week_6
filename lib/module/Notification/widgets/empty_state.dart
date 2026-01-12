import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class buildEmptyState extends StatelessWidget {
  const buildEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "All caught up!",
            style: GoogleFonts.cabin(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "You don't have any notifications right now.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

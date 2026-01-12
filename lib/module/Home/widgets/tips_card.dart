import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TipCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const TipCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.black87),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 3,
            style: GoogleFonts.cabin(
              color: Colors.black.withValues(alpha: 0.6),
              fontSize: 12,
              textStyle: TextStyle(overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }
}

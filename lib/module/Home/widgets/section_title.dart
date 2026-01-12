import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/utils/Extension/responsive_ui_extension.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionTitle extends StatelessWidget {
  String title;

  SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.cabin(
            textStyle: TextStyle(
              fontSize: context.responsiveTextSize(20),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Text(
          "See all",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: context.responsiveTextSize(14),
          ),
        ),
      ],
    );
  }
}

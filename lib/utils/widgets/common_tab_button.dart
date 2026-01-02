import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/providers/home_provider.dart';

class CommonTabButton extends StatefulWidget {
  final String label;
  final bool isActive;
  VoidCallback onTap;

  CommonTabButton({
    super.key,
    required this.label,
    this.isActive = false,
    required HomeProvider provider,
    required this.onTap,
  });
  @override
  State<CommonTabButton> createState() => CommonTabButtonState();
}

class CommonTabButtonState extends State<CommonTabButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 35.84,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: widget.isActive ? const Color(0xFF2E2D2D) : const Color(0xFFAEAEAE),
              ),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: widget.isActive ? const Color(0xFF2E2D2D) : const Color(0xFFAEAEAE),
                fontSize: 18,
                fontFamily: 'Cabin',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

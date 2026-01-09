import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/utils/theme/app_theme.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final String hint;
  final bool isObscure;
  String? Function(String?)? validator;

  CommonTextField({
    super.key,
    required this.ctrl,
    required this.label,
    required this.hint,
    this.isObscure = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ),
        TextFormField(
          controller: ctrl,
          validator: validator,
          cursorColor: AppTheme.primary,

          obscureText: isObscure,

          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppTheme.backgroundLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primary),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}

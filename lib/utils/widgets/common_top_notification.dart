import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

OverlayEntry? _previousEntry;

void showTopNotification(BuildContext context, String message, {bool isError = true}) {
  final overlay = Overlay.of(context);

  if (_previousEntry != null && _previousEntry!.mounted) {
    _previousEntry!.remove();
    _previousEntry = null;
  }
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 400),
          tween: Tween(begin: -100.0, end: 0.0),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.translate(offset: Offset(0, value), child: child);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isError ? AppTheme.surfaceDark : AppTheme.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: isError ? AppTheme.primary : Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  _previousEntry = entry;
  overlay.insert(entry);
  Future.delayed(const Duration(seconds: 3), () {
    if (entry.mounted) {
      entry.remove();

      if (_previousEntry == entry) {
        _previousEntry = null;
      }
    }
  });
}

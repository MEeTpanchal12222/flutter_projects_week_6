import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'common_text_style.dart';

enum SnackbarType { success, error }

class ToastUtils {
  static final FToast _fToast = FToast();

  static void showSnackBarWithVibration(
    BuildContext context,
    String? message,
    SnackbarType toastType, {
    VoidCallback? onTap,
    String? actionMsg,
  }) {
    // Initialize FToast only once
    _fToast.init(context);

    Color backgroundColor;
    switch (toastType) {
      case SnackbarType.success:
        backgroundColor = Colors.green;
        break;
      case SnackbarType.error:
        backgroundColor = Colors.red;
        break;
    }

    if (message != null) {
      // Remove existing toasts before showing a new one
      _fToast.removeCustomToast();

      _fToast.showToast(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: backgroundColor,
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            style: AppTextStyles.commonTextStyle(
              context: context,
              fontFamily: 'Rubik',
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
        toastDuration: const Duration(seconds: 2),
        positionedToastBuilder: (context, child, toast) {
          final mediaQuery = MediaQuery.maybeOf(context);
          final bottomInset = mediaQuery?.padding.bottom ?? 0;
          return Positioned(bottom: 30.0 + bottomInset, left: 0.0, right: 0.0, child: child);
        },
      );
    }
  }

  /// Call this function in dispose() of the screen to prevent crashes
  static void cancelToasts() {
    _fToast.removeCustomToast();
  }
}

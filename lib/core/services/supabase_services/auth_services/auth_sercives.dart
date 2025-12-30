import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/utils/widgets/common_tost.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase;
  AuthRepository(this._supabase);

  Future<void> signUp(String email, String password, String fullName, BuildContext context) async {
    try {
      await _supabase.auth.signUp(email: email, password: password, data: {'full_name': fullName});
    } on AuthException catch (e, st) {
      log("Error", name: "Sign Up", error: e, stackTrace: st);
      if (context.mounted) {
        ToastUtils.showSnackBarWithVibration(context, e.message.toString(), SnackbarType.error);
      }
    } catch (e) {
      log("Error", name: "Sign Up", error: e);
      if (context.mounted) {
        ToastUtils.showSnackBarWithVibration(
          context,
          "An unexpected error occurred during sign up.",
          SnackbarType.error,
        );
      }
    }
  }

  Future<void> signIn(String email, String password, BuildContext context) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e, st) {
      log("Error", name: "Sign In", error: e, stackTrace: st);
      if (context.mounted) {
        ToastUtils.showSnackBarWithVibration(context, e.message.toString(), SnackbarType.error);
      }
    } catch (e) {
      log("Error", name: "Sign In", error: e);
      if (context.mounted) {
        ToastUtils.showSnackBarWithVibration(
          context,
          "An unexpected error occurred during sign in.",
          SnackbarType.error,
        );
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e, st) {
      log("Error", name: "Sign Out", error: e, stackTrace: st);
    }
  }
}

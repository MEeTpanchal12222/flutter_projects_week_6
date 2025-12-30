import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/services/supabase_services/auth_services/auth_sercives.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;

  bool isLoading = false;
  BuildContext context;
  AuthProvider(this.context, this._repo);

  Future<void> signUp(String name, String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      await _repo.signUp(email, password, name, context);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

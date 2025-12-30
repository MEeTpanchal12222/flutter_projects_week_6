import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/services/supabase_services/auth_services/auth_services.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;
  AuthProvider(this._repo);

  // UI Controllers
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final userCtrl = TextEditingController();

  bool _isLoading = false;
  bool _isSignUp = false;
  bool _obscurePassword = true;

  bool get isLoading => _isLoading;
  bool get isSignUp => _isSignUp;
  bool get obscurePassword => _obscurePassword;

  void toggleAuthMode() {
    _isSignUp = !_isSignUp;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (!_isSignUp) return null; // Username only needed for signup

    if (value == null || value.trim().isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  Future<void> signUp(String name, String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repo.signUp(email, password, name, context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repo.signIn(email, password, context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

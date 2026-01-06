import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/services/supabase_services/auth_services/auth_services.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;
  AuthProvider(this._repo);

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final userCtrl = TextEditingController();

  bool _isLoading = false;
  bool _isSignUp = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _agreeToTerms = false;

  bool get isLoading => _isLoading;
  bool get isSignUp => _isSignUp;
  bool get obscurePassword => _obscurePassword;
  bool get rememberMe => _rememberMe;
  bool get agreeToTerms => _agreeToTerms;

  void toggleAuthMode() {
    _isSignUp = !_isSignUp;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  void toggleAgreeToTerms(bool value) {
    _agreeToTerms = value;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    final textToCheck = value ?? emailCtrl.text;

    if (textToCheck.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!textToCheck.contains('@') || !textToCheck.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    final textToCheck = value ?? passCtrl.text;

    if (textToCheck.isEmpty) {
      return 'Please enter a password';
    }
    if (textToCheck.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (!_isSignUp) return null;

    if (value == null || value.trim().isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  Future<void> signUp(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repo.signUp(emailCtrl.text, passCtrl.text, userCtrl.text, context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repo.signIn(emailCtrl.text, passCtrl.text, context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

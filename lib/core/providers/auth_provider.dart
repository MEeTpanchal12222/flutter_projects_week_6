import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/services/supabase_services/auth_services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;

  static const String _keyEmail = 'remembered_email';
  static const String _keyPass = 'remembered_password';
  static const String _keyRememberMe = 'remember_me_status';

  AuthProvider(this._repo) {
    _loadSavedCredentials();
  }

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final userCtrl = TextEditingController();
  final emailupCtrl = TextEditingController();
  final passwordupCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

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

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    _rememberMe = prefs.getBool(_keyRememberMe) ?? false;

    if (_rememberMe) {
      emailCtrl.text = prefs.getString(_keyEmail) ?? '';
      passCtrl.text = prefs.getString(_keyPass) ?? '';
    }
    notifyListeners();
  }

  Future<void> _handleRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString(_keyEmail, emailCtrl.text.trim());
      await prefs.setString(_keyPass, passCtrl.text.trim());
      await prefs.setBool(_keyRememberMe, true);
    } else {
      await prefs.remove(_keyEmail);
      await prefs.remove(_keyPass);
      await prefs.setBool(_keyRememberMe, false);
    }
  }

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

  String? validateEmail(String? value, {bool isSignUp = false}) {
    final textToCheck = isSignUp ? emailupCtrl.text : emailCtrl.text;

    if (textToCheck.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!textToCheck.contains('@') && !textToCheck.contains('.') && !textToCheck.contains('com')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value, {bool isSignUp = false}) {
    final textToCheck = isSignUp ? passwordupCtrl.text : passCtrl.text;

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
      await _repo.signUp(emailupCtrl.text, passwordupCtrl.text, userCtrl.text, context);
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
      await _handleRememberMe();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

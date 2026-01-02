import 'package:flutter/material.dart';
import '../services/supabase_services/database_services/profile_services.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repo;
  ProfileProvider(this._repo);

  Map<String, dynamic>? profile;
  bool isLoading = false;

  Future<void> loadProfile() async {
    isLoading = true;
    notifyListeners();
    try {
      profile = await _repo.getProfile();
    } catch (e) {
      debugPrint("Error loading profile: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
  }
}

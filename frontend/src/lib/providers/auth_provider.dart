import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserProfile? _user;
  bool _isLoading = false;
  String? _error;

  UserProfile? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _user = await _authService.login(email, password);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> updateProfile({
    UnitSystem? units,
    String? timezone,
    double? dailyThresholdMg,
  }) async {
    _user = await _authService.updateProfile(
      units: units,
      timezone: timezone,
      dailyThresholdMg: dailyThresholdMg,
    );
    notifyListeners();
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    _user = await _authService.changePassword(currentPassword, newPassword);
    notifyListeners();
  }
}

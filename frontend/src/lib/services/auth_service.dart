import '../models/user_profile.dart';

class AuthService {
  UserProfile _profile = UserProfile(
    email: 'yossie@eilaty.net',
    password: 'sabbabba',
    units: UnitSystem.metric,
    timezone: 'Israel',
    lastLogin: DateTime.now(),
  );

  Future<UserProfile> login(String email, String password) async {
    if (email == _profile.email && password == _profile.password) {
      return Future.delayed(
        const Duration(seconds: 1),
        () {
          _profile = _profile.copyWith(lastLogin: DateTime.now());
          return _profile;
        },
      );
    }
    throw Exception('Invalid credentials');
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<UserProfile> updateProfile({
    UnitSystem? units,
    String? timezone,
    double? dailyThresholdMg,
  }) async {
    return Future.delayed(const Duration(milliseconds: 300), () {
      _profile = _profile.copyWith(
        units: units,
        timezone: timezone,
        dailyThresholdMg: dailyThresholdMg,
      );
      return _profile;
    });
  }

  Future<UserProfile> changePassword(String currentPassword, String newPassword) async {
    return Future.delayed(const Duration(milliseconds: 300), () {
      if (currentPassword != _profile.password) {
        throw Exception('Current password is incorrect');
      }
      _profile = _profile.copyWith(password: newPassword);
      return _profile;
    });
  }
}

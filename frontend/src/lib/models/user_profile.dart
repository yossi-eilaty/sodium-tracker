enum UnitSystem { metric, imperial }

const double defaultDailyThresholdMg = 2300;

class UserProfile {
  final String email;
  final String password;
  final UnitSystem units;
  final String timezone;
  final double dailyThresholdMg;
  final DateTime lastLogin;

  UserProfile({
    required this.email,
    required this.password,
    required this.units,
    required this.timezone,
    this.dailyThresholdMg = defaultDailyThresholdMg,
    required this.lastLogin,
  });

  UserProfile copyWith({
    String? password,
    UnitSystem? units,
    String? timezone,
    double? dailyThresholdMg,
    DateTime? lastLogin,
  }) {
    return UserProfile(
      email: email,
      password: password ?? this.password,
      units: units ?? this.units,
      timezone: timezone ?? this.timezone,
      dailyThresholdMg: dailyThresholdMg ?? this.dailyThresholdMg,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user_profile.dart';
import 'providers/auth_provider.dart';

const List<String> _timezones = [
  'Israel',
  'UTC',
  'US/Eastern',
  'US/Pacific',
  'Europe/London',
  'Europe/Berlin',
];

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _thresholdController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late String _timezone;
  late UnitSystem _units;
  bool _isSavingProfile = false;
  bool _isChangingPassword = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _timezone = user != null && _timezones.contains(user.timezone) ? user.timezone : _timezones.first;
    _units = user?.units ?? UnitSystem.metric;
    _thresholdController.text = (user?.dailyThresholdMg ?? defaultDailyThresholdMg).toStringAsFixed(0);
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_profileFormKey.currentState!.validate()) return;

    setState(() => _isSavingProfile = true);
    await context.read<AuthProvider>().updateProfile(
          units: _units,
          timezone: _timezone,
          dailyThresholdMg: double.parse(_thresholdController.text),
        );
    setState(() => _isSavingProfile = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }

  Future<void> _changePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;

    setState(() => _isChangingPassword = true);
    try {
      await context.read<AuthProvider>().changePassword(
            _currentPasswordController.text,
            _newPasswordController.text,
          );
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isChangingPassword = false);
    }
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email', style: Theme.of(context).textTheme.bodySmall),
            Text(user?.email ?? '', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 20),
            Form(
              key: _profileFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Timezone'),
                  DropdownButtonFormField<String>(
                    initialValue: _timezone,
                    items: _timezones.map((tz) => DropdownMenuItem(value: tz, child: Text(tz))).toList(),
                    onChanged: (value) => setState(() => _timezone = value!),
                  ),
                  const SizedBox(height: 16),
                  const Text('Unit System'),
                  RadioGroup<UnitSystem>(
                    groupValue: _units,
                    onChanged: (value) => setState(() => _units = value!),
                    child: const Column(
                      children: [
                        RadioListTile<UnitSystem>(
                          title: Text('Metric'),
                          value: UnitSystem.metric,
                        ),
                        RadioListTile<UnitSystem>(
                          title: Text('Imperial'),
                          value: UnitSystem.imperial,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Daily Sodium Threshold (mg)'),
                  TextFormField(
                    controller: _thresholdController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      final parsed = double.tryParse(value ?? '');
                      return (parsed == null || parsed <= 0) ? 'Enter a valid amount' : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                    onPressed: _isSavingProfile ? null : _saveProfile,
                    child: _isSavingProfile
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('SAVE CHANGES'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Text('Change Password', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Form(
              key: _passwordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Password'),
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: true,
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Current password is required' : null,
                  ),
                  const SizedBox(height: 12),
                  const Text('New Password'),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    validator: (value) =>
                        (value == null || value.length < 4) ? 'Password must be at least 4 characters' : null,
                  ),
                  const SizedBox(height: 12),
                  const Text('Confirm New Password'),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    validator: (value) =>
                        value != _newPasswordController.text ? 'Passwords do not match' : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                    onPressed: _isChangingPassword ? null : _changePassword,
                    child: _isChangingPassword
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('CHANGE PASSWORD'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                foregroundColor: Colors.red,
              ),
              onPressed: _logout,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('LOG OUT'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

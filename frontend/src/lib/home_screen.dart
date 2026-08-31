import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import './add_food_screen.dart';
import './portion_calculator_screen.dart';
import './settings_screen.dart';
import './widgets/daily_sodium_status.dart';
import './widgets/day_navigator.dart';
import './widgets/log_history_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sodium Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome ${user?.email}', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 20),
              Text('Preferred Units: ${user?.units.name}'),
              Text('Timezone: ${user?.timezone}'),
              Text('Last Login: ${user?.lastLogin}'),
              const SizedBox(height: 20),
              const DayNavigator(),
              const SizedBox(height: 8),
              const DailySodiumStatus(),
              const SizedBox(height: 16),
              const LogHistoryList(),
              const SizedBox(height: 20),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddFoodScreen(),
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              SizedBox(width: 8),
              Text('LOG NEW FOOD INTAKE'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PortionCalculatorScreen(),
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calculate),
              SizedBox(width: 8),
              Text('OPEN PORTION CALCULATOR'),
            ],
          ),
        ),
      ],
    );
  }
}

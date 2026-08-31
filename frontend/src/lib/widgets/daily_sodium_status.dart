import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import '../providers/auth_provider.dart';
import '../providers/intake_provider.dart';

class DailySodiumStatus extends StatelessWidget {
  const DailySodiumStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final intakeProvider = Provider.of<IntakeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final total = intakeProvider.totalSodiumMg;
    final threshold = authProvider.user?.dailyThresholdMg ?? defaultDailyThresholdMg;
    final ratio = threshold > 0 ? (total / threshold).clamp(0.0, 1.0) : 0.0;
    final percent = threshold > 0 ? (total / threshold * 100).round() : 0;

    Color color;
    if (ratio >= 1.0) {
      color = Colors.red;
    } else if (ratio >= 0.75) {
      color = Colors.orange;
    } else {
      color = Colors.green;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${intakeProvider.dayLabel} SODIUM STATUS', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 10,
                color: color,
                backgroundColor: color.withValues(alpha: 0.2),
              ),
            ),
            const SizedBox(height: 8),
            Text('${total.toStringAsFixed(0)}mg / ${threshold.toStringAsFixed(0)}mg'),
            Text('Status: $percent% of daily threshold', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

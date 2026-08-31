import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/intake_provider.dart';

class LogHistoryList extends StatelessWidget {
  const LogHistoryList({super.key});

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatAmount(double amount) {
    return amount % 1 == 0 ? amount.toStringAsFixed(0) : amount.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final intakeProvider = Provider.of<IntakeProvider>(context);
    final entries = intakeProvider.entries;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${intakeProvider.dayLabel} LOG HISTORY', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (entries.isEmpty)
              const Text('No food logged for this day.')
            else
              ...entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_formatTime(entry.timestamp)} - ${entry.foodName} '
                          '(${_formatAmount(entry.amount)} ${entry.unitLabel}) - ${entry.sodiumMg.toStringAsFixed(0)}mg',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        tooltip: 'Delete entry',
                        onPressed: () => intakeProvider.deleteEntry(entry.id),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

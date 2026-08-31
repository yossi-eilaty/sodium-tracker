import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/intake_provider.dart';

class DayNavigator extends StatelessWidget {
  const DayNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final intakeProvider = Provider.of<IntakeProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: intakeProvider.goToPreviousDay,
        ),
        Text(
          intakeProvider.isToday ? 'Today' : intakeProvider.dayLabel,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: intakeProvider.canGoForward ? intakeProvider.goToNextDay : null,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/consumption_unit.dart';
import 'models/food_portion.dart';
import 'models/intake_entry.dart';
import 'models/user_profile.dart';
import 'providers/auth_provider.dart';
import 'providers/intake_provider.dart';
import 'providers/portion_provider.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _amountController = TextEditingController(text: '1');

  FoodPortion? _selectedPortion;
  ConsumptionUnit _unit = ConsumptionUnit.count;

  @override
  void initState() {
    super.initState();
    final portionProvider = context.read<PortionProvider>();
    if (portionProvider.portions.isEmpty) {
      portionProvider.loadPortions();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _amount => double.tryParse(_amountController.text) ?? 0;

  double get _totalSodium {
    final portion = _selectedPortion;
    if (portion == null) return 0;
    if (_unit == ConsumptionUnit.count) {
      return portion.sodiumPerPortion * _amount;
    }
    return portion.sodiumPerReferenceUnit * _amount / 100;
  }

  String get _amountUnitLabel {
    if (_unit == ConsumptionUnit.count) return 'portions';
    return _selectedPortion?.unitLabel ?? '';
  }

  void _selectPortion(FoodPortion? portion) {
    setState(() {
      _selectedPortion = portion;
      if (portion != null) {
        _unit = portion.defaultLoggingUnit;
      }
    });
  }

  Future<void> _proceedToLog() async {
    final portion = _selectedPortion;
    if (portion == null || _amount <= 0) return;

    final intakeProvider = context.read<IntakeProvider>();
    final threshold = context.read<AuthProvider>().user?.dailyThresholdMg ?? defaultDailyThresholdMg;
    final sodium = _totalSodium;
    final projectedTotal = intakeProvider.totalSodiumMg + sodium;
    final projectedPercent = (projectedTotal / threshold * 100).round();

    if (projectedTotal >= threshold * 0.9) {
      if (!mounted) return;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('⚠️ THRESHOLD WARNING'),
          content: Text(
            'Adding ${portion.name} (${sodium.toStringAsFixed(1)}mg) will bring your total to '
            '${projectedTotal.toStringAsFixed(1)}mg.\n\n'
            'This approaches your daily target of ${threshold.toStringAsFixed(0)}mg '
            '($projectedPercent%).\n\n'
            'Do you still want to consume this?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('YES, LOG ANYWAY'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    await _logEntry(portion, sodium);
  }

  Future<void> _logEntry(FoodPortion portion, double sodium) async {
    final intakeProvider = context.read<IntakeProvider>();
    await intakeProvider.addEntry(
      IntakeEntry(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        foodName: portion.name,
        unitLabel: _amountUnitLabel,
        amount: _amount,
        sodiumMg: sodium,
        timestamp: DateTime.now(),
      ),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged ${portion.name} - ${sodium.toStringAsFixed(1)}mg')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final portionProvider = context.watch<PortionProvider>();
    final portions = portionProvider.portions;

    if (_selectedPortion == null && portions.isNotEmpty) {
      _selectedPortion = portions.first;
      _unit = _selectedPortion!.defaultLoggingUnit;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Log Food Intake')),
      body: portionProvider.isLoading && portions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : portions.isEmpty
              ? const Center(child: Text('No portions available. Create one with the Portion Calculator first.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Selected Item'),
                      DropdownButtonFormField<FoodPortion>(
                        initialValue: _selectedPortion,
                        items: portions
                            .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                            .toList(),
                        onChanged: _selectPortion,
                      ),
                      if (_selectedPortion != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '(Defined as: ${_selectedPortion!.portionUnitAmount.toStringAsFixed(0)}'
                          '${_selectedPortion!.unitLabel} per single portion)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(height: 20),
                      const Text('Select Consumption Unit'),
                      RadioGroup<ConsumptionUnit>(
                        groupValue: _unit,
                        onChanged: (value) => setState(() => _unit = value!),
                        child: Column(
                          children: [
                            const RadioListTile<ConsumptionUnit>(
                              title: Text('Count (Portions/Items)'),
                              value: ConsumptionUnit.count,
                            ),
                            RadioListTile<ConsumptionUnit>(
                              title: Text(
                                _selectedPortion?.basis == ReferenceBasis.per100ml
                                    ? 'Volume in Milliliters'
                                    : 'Weight in Grams',
                              ),
                              value: ConsumptionUnit.weightOrVolume,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Enter Amount'),
                      TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(suffixText: _amountUnitLabel),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Total Sodium for this Intake: ${_totalSodium.toStringAsFixed(1)} mg',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                        onPressed: _selectedPortion == null || _amount <= 0 ? null : _proceedToLog,
                        child: const Text('PROCEED TO LOG'),
                      ),
                    ],
                  ),
                ),
    );
  }
}

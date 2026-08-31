import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/consumption_unit.dart';
import 'models/food_portion.dart';
import 'providers/portion_provider.dart';

enum _InputMode { manual, aiLookup }

class PortionCalculatorScreen extends StatefulWidget {
  const PortionCalculatorScreen({super.key});

  @override
  State<PortionCalculatorScreen> createState() => _PortionCalculatorScreenState();
}

class _PortionCalculatorScreenState extends State<PortionCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _sodiumPerRefController = TextEditingController();
  final _portionAmountController = TextEditingController();
  final _tagsController = TextEditingController();

  _InputMode _inputMode = _InputMode.manual;
  ReferenceBasis _basis = ReferenceBasis.per100g;
  ConsumptionUnit _defaultLoggingUnit = ConsumptionUnit.count;
  bool _shareWithCommunity = false;
  bool _isSaving = false;

  double get _calculatedSodium {
    final perRef = double.tryParse(_sodiumPerRefController.text) ?? 0;
    final amount = double.tryParse(_portionAmountController.text) ?? 0;
    return perRef * amount / 100;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sodiumPerRefController.dispose();
    _portionAmountController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final portion = FoodPortion(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      basis: _basis,
      sodiumPerReferenceUnit: double.parse(_sodiumPerRefController.text),
      portionUnitAmount: double.parse(_portionAmountController.text),
      defaultLoggingUnit: _defaultLoggingUnit,
      tags: tags,
      shared: _shareWithCommunity,
    );

    setState(() => _isSaving = true);
    await context.read<PortionProvider>().addPortion(portion);
    setState(() => _isSaving = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${portion.name} saved to your portions')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final basisLabel = _basis == ReferenceBasis.per100g ? '100 Grams' : '100 ml';

    return Scaffold(
      appBar: AppBar(title: const Text('Portion Calculator')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Portion Name'),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Cookie'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 20),
              const Text('Input Mode'),
              RadioGroup<_InputMode>(
                groupValue: _inputMode,
                onChanged: (value) => setState(() => _inputMode = value!),
                child: Column(
                  children: const [
                    RadioListTile<_InputMode>(
                      title: Text('Manual Entry'),
                      value: _InputMode.manual,
                    ),
                    RadioListTile<_InputMode>(
                      title: Text('AI Web Lookup (coming soon)'),
                      value: _InputMode.aiLookup,
                      enabled: false,
                    ),
                  ],
                ),
              ),
              const Divider(),
              const Text('Reference Basis'),
              RadioGroup<ReferenceBasis>(
                groupValue: _basis,
                onChanged: (value) => setState(() => _basis = value!),
                child: Column(
                  children: const [
                    RadioListTile<ReferenceBasis>(
                      title: Text('Per 100 Grams'),
                      value: ReferenceBasis.per100g,
                    ),
                    RadioListTile<ReferenceBasis>(
                      title: Text('Per 100 ml'),
                      value: ReferenceBasis.per100ml,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text('Sodium per Reference Unit (mg)'),
              TextFormField(
                controller: _sodiumPerRefController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  return (parsed == null || parsed < 0) ? 'Enter a valid number' : null;
                },
              ),
              const SizedBox(height: 12),
              Text('Portion Base Unit Weight/Volume ($basisLabel basis)'),
              TextFormField(
                controller: _portionAmountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  return (parsed == null || parsed <= 0) ? 'Enter a valid amount' : null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Calculated Sodium per Portion Unit: ${_calculatedSodium.toStringAsFixed(1)} mg',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              const Text('Default Logging Unit'),
              RadioGroup<ConsumptionUnit>(
                groupValue: _defaultLoggingUnit,
                onChanged: (value) => setState(() => _defaultLoggingUnit = value!),
                child: Column(
                  children: [
                    const RadioListTile<ConsumptionUnit>(
                      title: Text('By Count (Portions/Items)'),
                      value: ConsumptionUnit.count,
                    ),
                    RadioListTile<ConsumptionUnit>(
                      title: Text(
                        _basis == ReferenceBasis.per100ml ? 'By Volume (ml)' : 'By Weight (g)',
                      ),
                      value: ConsumptionUnit.weightOrVolume,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text('Tags (comma separated)'),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(hintText: 'snack, bakery, sweet'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Share with global community?'),
                value: _shareWithCommunity,
                onChanged: (value) => setState(() => _shareWithCommunity = value),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('SAVE TO MY PORTIONS'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

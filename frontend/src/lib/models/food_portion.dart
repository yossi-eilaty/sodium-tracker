import 'consumption_unit.dart';

enum ReferenceBasis { per100g, per100ml }

class FoodPortion {
  final String id;
  final String name;
  final ReferenceBasis basis;
  final double sodiumPerReferenceUnit;
  final double portionUnitAmount;
  final ConsumptionUnit defaultLoggingUnit;
  final List<String> tags;
  final bool shared;

  FoodPortion({
    required this.id,
    required this.name,
    required this.basis,
    required this.sodiumPerReferenceUnit,
    required this.portionUnitAmount,
    this.defaultLoggingUnit = ConsumptionUnit.count,
    this.tags = const [],
    this.shared = false,
  });

  double get sodiumPerPortion => sodiumPerReferenceUnit * portionUnitAmount / 100;

  String get unitLabel => basis == ReferenceBasis.per100g ? 'g' : 'ml';
}

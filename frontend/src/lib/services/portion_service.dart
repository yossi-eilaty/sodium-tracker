import '../models/consumption_unit.dart';
import '../models/food_portion.dart';

class PortionService {
  final List<FoodPortion> _portions = [
    FoodPortion(
      id: '1',
      name: 'Bamba (Small Bag)',
      basis: ReferenceBasis.per100g,
      sodiumPerReferenceUnit: 400,
      portionUnitAmount: 30,
      defaultLoggingUnit: ConsumptionUnit.count,
      tags: const ['snack'],
      shared: true,
    ),
    FoodPortion(
      id: '2',
      name: 'Cottage Cheese',
      basis: ReferenceBasis.per100g,
      sodiumPerReferenceUnit: 400,
      portionUnitAmount: 100,
      defaultLoggingUnit: ConsumptionUnit.weightOrVolume,
      tags: const ['dairy'],
      shared: true,
    ),
    FoodPortion(
      id: '3',
      name: 'Tomato Soup (1 bowl)',
      basis: ReferenceBasis.per100ml,
      sodiumPerReferenceUnit: 340,
      portionUnitAmount: 250,
      defaultLoggingUnit: ConsumptionUnit.count,
      tags: const ['soup'],
      shared: true,
    ),
    FoodPortion(
      id: '4',
      name: 'Cookie',
      basis: ReferenceBasis.per100g,
      sodiumPerReferenceUnit: 450,
      portionUnitAmount: 25,
      defaultLoggingUnit: ConsumptionUnit.count,
      tags: const ['snack', 'bakery', 'sweet'],
      shared: false,
    ),
  ];

  Future<List<FoodPortion>> getPortions() async {
    return Future.delayed(const Duration(milliseconds: 300), () => List.unmodifiable(_portions));
  }

  Future<FoodPortion> addPortion(FoodPortion portion) async {
    return Future.delayed(const Duration(milliseconds: 300), () {
      _portions.add(portion);
      return portion;
    });
  }
}

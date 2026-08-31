import 'package:flutter/material.dart';
import '../models/food_portion.dart';
import '../services/portion_service.dart';

class PortionProvider extends ChangeNotifier {
  final PortionService _service = PortionService();

  List<FoodPortion> _portions = [];
  bool _isLoading = false;

  List<FoodPortion> get portions => _portions;
  bool get isLoading => _isLoading;

  Future<void> loadPortions() async {
    try {
      _isLoading = true;
      notifyListeners();

      _portions = await _service.getPortions();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPortion(FoodPortion portion) async {
    await _service.addPortion(portion);
    _portions = [..._portions, portion];
    notifyListeners();
  }
}

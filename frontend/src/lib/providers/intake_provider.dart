import 'package:flutter/material.dart';
import '../models/intake_entry.dart';
import '../services/intake_service.dart';

const List<String> _weekdayAbbrev = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const List<String> _monthAbbrev = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

class IntakeProvider extends ChangeNotifier {
  final IntakeService _service = IntakeService();

  List<IntakeEntry> _allEntries = [];
  bool _isLoading = false;
  DateTime _selectedDate = _dateOnly(DateTime.now());

  bool get isLoading => _isLoading;

  static DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  bool get isToday => _selectedDate == _dateOnly(DateTime.now());

  bool get canGoForward => _selectedDate.isBefore(_dateOnly(DateTime.now()));

  String get dayLabel {
    if (isToday) return "TODAY'S";
    final weekday = _weekdayAbbrev[_selectedDate.weekday - 1];
    final month = _monthAbbrev[_selectedDate.month - 1];
    final day = _selectedDate.day.toString().padLeft(2, '0');
    return '$weekday $month-$day-${_selectedDate.year}';
  }

  List<IntakeEntry> get entries {
    final filtered = _allEntries.where((e) => _dateOnly(e.timestamp) == _selectedDate).toList();
    filtered.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return filtered;
  }

  double get totalSodiumMg => entries.fold(0.0, (sum, e) => sum + e.sodiumMg);

  void goToPreviousDay() {
    _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    notifyListeners();
  }

  void goToNextDay() {
    if (!canGoForward) return;
    _selectedDate = _selectedDate.add(const Duration(days: 1));
    notifyListeners();
  }

  Future<void> loadEntries() async {
    try {
      _isLoading = true;
      notifyListeners();

      _allEntries = await _service.getAllEntries();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEntry(IntakeEntry entry) async {
    await _service.addEntry(entry);
    _allEntries = [..._allEntries, entry];
    notifyListeners();
  }

  Future<void> deleteEntry(String id) async {
    await _service.deleteEntry(id);
    _allEntries = _allEntries.where((e) => e.id != id).toList();
    notifyListeners();
  }
}

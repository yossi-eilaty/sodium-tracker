import '../models/intake_entry.dart';

class IntakeService {
  final List<IntakeEntry> _entries = [];

  Future<List<IntakeEntry>> getAllEntries() async {
    return Future.delayed(const Duration(milliseconds: 300), () => List.unmodifiable(_entries));
  }

  Future<IntakeEntry> addEntry(IntakeEntry entry) async {
    return Future.delayed(const Duration(milliseconds: 300), () {
      _entries.add(entry);
      return entry;
    });
  }

  Future<void> deleteEntry(String id) async {
    return Future.delayed(const Duration(milliseconds: 300), () {
      _entries.removeWhere((e) => e.id == id);
    });
  }
}

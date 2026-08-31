class IntakeEntry {
  final String id;
  final String foodName;
  final String unitLabel;
  final double amount;
  final double sodiumMg;
  final DateTime timestamp;

  IntakeEntry({
    required this.id,
    required this.foodName,
    required this.unitLabel,
    required this.amount,
    required this.sodiumMg,
    required this.timestamp,
  });
}

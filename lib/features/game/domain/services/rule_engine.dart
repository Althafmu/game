import '../models/cell.dart';

class RuleEngine {
  static bool isPairValid(Cell a, Cell b) {
    if (a.matched || b.matched || a.id == b.id) return false;
    final sum = a.value + b.value;
    return (a.value == b.value) || (sum == 10);
  }
}

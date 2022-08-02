import 'cell.dart';

class Ship {
  final List<Cell> cells;
  final bool isHorizontal;
  final int length;
  var _hitsTaken = 0;

  Ship(this.cells, this.isHorizontal, this.length);

  bool takeHit() {
    _hitsTaken++;
    if (_hitsTaken == length) {
      return true;
    } else {
      return false;
    }
  }
}

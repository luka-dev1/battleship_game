import 'cell.dart';

class Ship {
  final List<Cell> cells;
  final bool isHorizontal;
  final int length;
  int hitsTaken = 0;

  Ship(this.cells, this.isHorizontal, this.length);

  bool takeHit() {
    hitsTaken++;
    if (hitsTaken == length) {
      return true;
    } else {
      return false;
    }
  }
}

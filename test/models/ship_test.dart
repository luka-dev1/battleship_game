import 'package:battle/models/cell.dart';
import 'package:battle/models/ship.dart';
import 'package:test/test.dart';

void main() {
  test("Ship.hitsTaken() should return true if all ships cells are  hit", () {
    final ship = Ship([Cell(1, 0), Cell(1, 1)], true, 2);
    var didSink = ship.takeHit();
    didSink = ship.takeHit();
    expect(didSink, true);
  });
}

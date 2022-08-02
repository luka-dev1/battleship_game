import 'package:battle/models/cell.dart';
import 'package:test/test.dart';

void main() {
  test("Cells value should change", () {
    final cell = Cell(1, 0);
    cell.setValue(1);
    expect(cell.value, 1);
  });
}

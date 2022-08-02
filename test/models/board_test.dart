import 'package:battle/models/board.dart';
import 'package:battle/models/cell.dart';
import 'package:battle/models/ship.dart';
import 'package:test/test.dart';

void main() {
  group("Board", () {
    test('should contain grid of cells each with value 0 at initialization',
        () {
      final board = Board();
      for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
          expect(board.cells[i][j].value, 0);
        }
      }
    });

    test('.populate() should populate the board with exactly five ships', () {
      final board = Board();
      board.populate();
      expect(board.ships.length, 5);
    });

    test(
        '.placeShip(5) should return a ship object containing exactly five cells',
        () {
      final board = Board();
      expect(board.placeShip(5).cells.length, 5);
    });

    test(
        ".checkAvailableSpace() should return false when the horizontal ship doesn't fit on the board",
        () {
      final board = Board();
      expect(board.checkAvailableSpace(true, 5, 0, 6), false);
    });

    test(
        ".checkAvailableSpace() should return false when the vertical ship doesn't fit on the board",
        () {
      final board = Board();
      expect(board.checkAvailableSpace(false, 5, 8, 5), false);
    });

    test(".checkCollisions() should detect a collision", () {
      final board = Board();
      board.cells[5][5].setValue(1);
      expect(board.checkCollisions(true, 2, 5, 4), true);
    });

    test(
        ".fillSurroundings() should fill all of the ships neighbouring cells with 2's",
        () {
      final board = Board();
      final ship = Ship([Cell(5, 5), Cell(5, 6)], true, 2);
      board.fillSurroundings(ship);
      expect(board.cells[5][4].value, 2);
      expect(board.cells[5][7].value, 2);
      for (int j = 4; j < 8; j++) {
        expect(board.cells[4][j].value, 2);
      }
      for (int j = 4; j < 8; j++) {
        expect(board.cells[6][j].value, 2);
      }
    });

    test(".checkGuess() should detect a Hit", () {
      final board = Board();
      board.populate();
      var i = board.ships[0].cells.first.i;
      var j = board.ships[0].cells.first.j;
      var result = board.checkGuess(i, j);
      expect(result, "Hit");
    });

    test(".findShip() should find a ship on the board", () {
      final board = Board();
      board.populate();
      var ship = board.findShip(board.ships.first.cells.last);
      expect(ship.cells.first.i, board.ships.first.cells.first.i);
    });
  });
}

import 'package:battle/models/board.dart';
import 'package:battle/models/player.dart';
import 'package:test/test.dart';

void main() {
  group("Player", () {
    test(".randomGuess() should generate a random guess", () {
      final board = Board();
      final player = Player();
      board.populate();
      var guessCell = player.randomGuess(board);
      expect(guessCell.length, 2);
    });

    test(
        ".findNeighbour() should find the next empty cell from the given spot [i, j].",
        () {
      final player = Player();
      player.lastHitGuess = Guess(1, 0, true, false);
      player.guessChain = [Guess(1, 0, true, false)];
      player.guessBoard.cells[1][0].setValue(1);
      var guessCell = player.findNeighbour();
      expect(guessCell, [1, 1]);
    });

    test(
        ".findHorizontal() should find the next empty horizontal cell from the given spot [i, j].",
        () {
      final player = Player();
      player.lastHitGuess = Guess(1, 0, true, false);
      player.guessChain = [Guess(1, 1, true, false), Guess(1, 0, true, false)];
      player.guessBoard.cells[1][0].setValue(1);
      player.guessBoard.cells[1][1].setValue(1);
      var guessCell = player.findHorizontal(1, 0);
      expect(guessCell, [1, 2]);
    });

    test(
        ".findVertical() should find the next empty vertical cell from the given spot [i, j].",
        () {
      final player = Player();
      player.lastHitGuess = Guess(0, 0, true, false);
      player.guessChain = [
        Guess(1, 1, true, false),
        Guess(2, 0, true, false),
        Guess(3, 0, true, false),
        Guess(0, 0, true, false),
      ];
      player.guessBoard.cells[0][0].setValue(1);
      player.guessBoard.cells[1][0].setValue(1);
      player.guessBoard.cells[2][0].setValue(1);
      player.guessBoard.cells[3][0].setValue(1);
      var guessCell = player.findVertical(0, 0);
      expect(guessCell, [4, 0]);
    });

    test(
        ".createShipFromChain() should generate a ship from a chain of guesses",
        () {
      final player = Player();
      var chain = [Guess(1, 1, true, false), Guess(1, 0, true, true)];
      var ship = player.createShipFromChain(chain);
      expect(ship.cells.first.j, 0);
      expect(ship.cells.length, 2);
    });
  });
}

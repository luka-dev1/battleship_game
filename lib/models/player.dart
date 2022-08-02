import 'dart:math';

import 'package:battle/models/ship.dart';

import 'board.dart';
import 'cell.dart';

class Player {
  /// Used to generate random values.
  final rand = Random();

  /// Tracks how many of the opponents ships are left.
  /// (5 + 4 + 3 + 3 + 2 = 17)
  var shipsToDestroy = 17;

  /// Stores last correct guess.
  var lastHitGuess = Guess(-1, -1, false, false);

  /// Stores a list of consecutive correct guesses.
  var guessChain = <Guess>[];

  /// Players board.
  var board = Board();

  /// Empty board that tracks players guesses.
  var guessBoard = Board();

  /// Indicator if the player has won.
  var didWin = false;

  /// Creates a new guess.
  bool guess(Board board) {
    /// Stores new guess coordinates.
    List<int> guessCell;

    /// Checks if the last guess was correct.
    ///
    /// If so, proceed to a calculated guess. Otherwise, do a random guess.
    if (lastHitGuess.didHit && !lastHitGuess.didSink) {
      guessCell = calculatedGuess(board);
    } else {
      guessCell = randomGuess(board);
    }

    /// Submits new guess coordinates.
    var i = guessCell[0];
    var j = guessCell[1];
    var result = board.checkGuess(i, j);

    /// If the guess is correct and has sunken a ship:
    ///   - reduces number of ships to destroy.
    ///   - resets lastHit guess.
    ///   - clears current guess chain.
    ///   - checks if there are no ships left to destroy.
    ///   - fills surrounding area of the sunken ship on the guessBoard.
    ///   - returns true.
    if (result == "Sink") {
      lastHitGuess = Guess(i, j, true, true);
      guessChain.add(lastHitGuess);
      var ship = createShipFromChain(guessChain);
      guessBoard.cells[i][j].setValue(4);
      shipsToDestroy -= guessChain.length;
      lastHitGuess = Guess(-1, -1, false, false);
      guessChain.clear();
      if (shipsToDestroy == 0) {
        didWin = true;
      }
      guessBoard.fillSurroundings(ship);
      return true;
    }

    /// If the guess is correct:
    ///   - stores this guess as a lastHit guess.
    ///   - ads this guess to a chain of hit guesses.
    ///   - returns true.
    else if (result == "Hit") {
      guessBoard.cells[i][j].setValue(4);
      lastHitGuess = Guess(i, j, true, false);
      guessChain.add(lastHitGuess);
      return true;
    }

    /// If the guess was incorrect returns false.
    else {
      guessBoard.cells[i][j].setValue(2);
      return false;
    }
  }

  /// Randomly guesses opponents ship position.
  List<int> randomGuess(Board board) {
    var i = rand.nextInt(10);
    var j = rand.nextInt(10);

    /// If the cell with coordinates [i, j] is empty (value = 0),
    /// return it.
    if (guessBoard.cells[i][j].value == 0) {
      return [i, j];
    } else {
      return randomGuess(board);
    }
  }

  /// Guesses opponents ship position based on the previous correct guess.
  List<int> calculatedGuess(Board board) {
    /// Finds neighbouring cell of the previous correct cell guessed.
    List<int> neighbour = findNeighbour();
    var i = neighbour[0];
    var j = neighbour[1];

    return [i, j];
  }

  /// Finds neighbouring cell of the previous correct cell guessed.
  List<int> findNeighbour() {
    var i = lastHitGuess.i;
    var j = lastHitGuess.j;
    try {
      List<int> newCell;

      /// If there were consecutive correct guesses we can calculate
      /// the orientation of the opponents ship and the next cell
      /// to guess.
      if (guessChain.length > 1) {
        if (guessChain[0].i == guessChain[1].i) {
          newCell = findHorizontal(i, j);
        } else {
          newCell = findVertical(i, j);
        }
      } else {
        /// Otherwise, first try with the horizontal cells then
        /// with vertical.
        newCell = findHorizontal(i, j);
        if (newCell[0] == -1 || newCell[1] == -1) {
          newCell = findVertical(i, j);
        }
      }

      /// If there are no empty cells to be found something went wrong.
      if (newCell[0] == -1 || newCell[1] == -1) {
        throw Exception("No empty neighbours");
      } else {
        return newCell;
      }
    } on Exception catch (e) {
      print(e);
    }
    return [-1, -1];
  }

  /// Finds the next empty horizontal cell from the given spot [i, j].
  List<int> findHorizontal(int i, int j) {
    while (j - 1 >= 0) {
      j = j - 1;
      if (guessBoard.cells[i][j].value == 0) {
        return [i, j];
      } else if (guessBoard.cells[i][j].value == 2) {
        break;
      }
    }
    while (j + 1 <= 9) {
      j = j + 1;
      if (guessBoard.cells[i][j].value == 0) {
        return [i, j];
      } else if (guessBoard.cells[i][j].value == 2) {
        break;
      }
    }
    return [-1, -1];
  }

  /// Finds the next empty vertical cell from the given spot [i, j].
  List<int> findVertical(int i, int j) {
    while (i - 1 >= 0) {
      i = i - 1;
      if (guessBoard.cells[i][j].value == 0) {
        return [i, j];
      } else if (guessBoard.cells[i][j].value == 2) {
        break;
      }
    }
    while (i + 1 <= 9) {
      i = i + 1;
      if (guessBoard.cells[i][j].value == 0) {
        return [i, j];
      } else if (guessBoard.cells[i][j].value == 2) {
        break;
      }
    }
    return [-1, -1];
  }

  Ship createShipFromChain(List<Guess> chain) {
    var isHorizontal = false;
    if (chain[0].i == chain[1].i) {
      isHorizontal = true;
    }
    if (isHorizontal) {
      chain.sort((a, b) => a.j.compareTo(b.j));
    } else {
      chain.sort((a, b) => a.i.compareTo(b.i));
    }
    var cells = <Cell>[];
    for (Guess guess in chain) {
      cells.add(Cell(guess.i, guess.j));
    }
    return Ship(cells, isHorizontal, chain.length);
  }
}

class Guess {
  final int i;
  final int j;
  final bool didHit;
  final bool didSink;

  Guess(this.i, this.j, this.didHit, this.didSink);
}

import 'dart:math';

import 'board.dart';

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
    Guess currentGuess;

    /// Checks if the last guess was correct.
    ///
    /// If so, proceed to a calculated guess. Otherwise, do a random guess.
    if (lastHitGuess.didHit && !lastHitGuess.didSink) {
      currentGuess = calculatedGuess(board, lastHitGuess.i, lastHitGuess.j);
    } else {
      currentGuess = randomGuess(board);
    }

    /// If the guess is correct, stores it, adds it to the guess chain
    /// and checks if the guess has sunken opponents ship.
    if (currentGuess.didHit) {
      lastHitGuess = currentGuess;
      guessChain.add(lastHitGuess);
      if (currentGuess.didSink) {
        /// Subtracts the sunken ship's length from the ships
        /// left to destroy.
        shipsToDestroy -= guessChain.length;

        /// If there are no ships left the player has won.
        if (shipsToDestroy == 0) {
          didWin = true;
        }

        /// Fills the surrounding area of the sunken ship indicating that
        /// there is now other ship there.
        var isHorizontal =
            guessBoard.getOrientation(currentGuess.i, currentGuess.j);
        guessBoard.fillSurroundingsTwo(
            isHorizontal, currentGuess.i, currentGuess.j);

        /// Resets last guess and the guess chain.
        lastHitGuess = Guess(-1, -1, false, false);
        guessChain.clear();
      }

      /// returns true if the guess was correct.
      return true;
    } else {
      return false;
    }
  }

  /// Randomly guesses opponents ship position.
  Guess randomGuess(Board board) {
    var i = rand.nextInt(10);
    var j = rand.nextInt(10);
    if (guessBoard.grid[i][j] == 0) {
      var result = board.checkGuess(i, j);
      return checkResult(result, i, j);
    } else {
      return randomGuess(board);
    }
  }

  /// Guesses opponents ship position based on the previous correct guess.
  Guess calculatedGuess(Board board, int i, int j) {
    /// Finds neighbouring cell of the previous correct cell guessed.
    List<int> neighbour = findNeighbour(i, j);
    var newI = neighbour[0];
    var newJ = neighbour[1];

    /// Submits a new guess.
    var result = board.checkGuess(newI, newJ);
    return checkResult(result, newI, newJ);
  }

  /// Finds neighbouring cell of the previous correct cell guessed.
  List<int> findNeighbour(int i, int j) {
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
      if (guessBoard.grid[i][j] == 0) {
        return [i, j];
      } else if (guessBoard.grid[i][j] == 2) {
        break;
      }
    }
    while (j + 1 <= 9) {
      j = j + 1;
      if (guessBoard.grid[i][j] == 0) {
        return [i, j];
      } else if (guessBoard.grid[i][j] == 2) {
        break;
      }
    }
    return [-1, -1];
  }

  /// Finds the next empty vertical cell from the given spot [i, j].
  List<int> findVertical(int i, int j) {
    while (i - 1 >= 0) {
      i = i - 1;
      if (guessBoard.grid[i][j] == 0) {
        return [i, j];
      } else if (guessBoard.grid[i][j] == 2) {
        break;
      }
    }
    while (i + 1 <= 9) {
      i = i + 1;
      if (guessBoard.grid[i][j] == 0) {
        return [i, j];
      } else if (guessBoard.grid[i][j] == 2) {
        break;
      }
    }
    return [-1, -1];
  }

  /// Checks the opponents answer to the player's guess and returns a new
  /// Guess object with the appropriate parameters.
  Guess checkResult(String result, int i, int j) {
    bool didHit = false;
    bool didSink = false;
    if (result == 'Sink') {
      didHit = true;
      didSink = true;
      guessBoard.grid[i][j] = 1;
    } else if (result == 'Hit') {
      didHit = true;
      guessBoard.grid[i][j] = 1;
    } else {
      guessBoard.grid[i][j] = 2;
    }
    //_guessBoard.printGrid();
    return Guess(i, j, didHit, didSink);
  }
}

class Guess {
  final int i;
  final int j;
  final bool didHit;
  final bool didSink;

  Guess(this.i, this.j, this.didHit, this.didSink);
}

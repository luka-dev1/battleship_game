import 'dart:math';

import 'package:battle/models/ship.dart';

import 'cell.dart';

class Board {
  /// Used to generate random values.
  final rand = Random();

  /// 10 x 10 grid with all of the cells set to 0.
  /// (number 0 indicates that the cell is empty)
  var cells =
      List.generate(10, (i) => List<Cell>.generate(10, (j) => Cell(i, j)));

  /// Live ships still on the board
  var ships = <Ship>[];

  /*void printBoard() {
    for (int i = 0; i < 10; i++) {
      var row = "";
      for (var cell in cells[i]) {
        row += "${cell.value} ";
      }
      print(row);
    }
  }*/

  /// Populates the board with 5 different ships.
  void populate() {
    /*cells =
        List.generate(10, (i) => List<Cell>.generate(10, (j) => Cell(i, j)));*/

    /// List of available ships to place.
    var shipLengths = [2, 3, 3, 4, 5];

    for (int shipLength in shipLengths) {
      /// Tries to place a ship on the board and keeps trying until successful.
      var ship = placeShip(shipLength);
      ships.add(ship);
    }
  }

  /// Places a ship on the board.
  Ship placeShip(int shipLength) {
    /// Randomly chooses initial spot to place the ship and places
    /// its coordinates into two variables: i and j.
    var initialSpot = chooseInitialSpot();
    var i = initialSpot[0];
    var j = initialSpot[1];

    /// Randomly chooses the orientation of the ship.
    var isHorizontal = rand.nextBool();

    /// Checks if there is available space starting at this spot
    /// for the ship of given size and orientation.
    ///
    /// If the space does exist fill out all of the cells with 1's,
    /// starting from the chosen spot and going to the right
    /// if the ship is horizontal or going downwards if the ship is vertical,
    /// indicating that each cell contains a part of the ship.
    ///
    /// FIll out surrounding area (cells) of the ship indicating that
    /// no other ship can be placed there.
    ///
    /// If there is no space, calls the function again.
    var spaceExists = checkAvailableSpace(isHorizontal, shipLength, i, j);
    if (spaceExists) {
      var shipCells = <Cell>[];
      if (isHorizontal) {
        for (int k = j; k < shipLength + j; k++) {
          cells[i][k].setValue(1);
          shipCells.add(cells[i][k]);
        }
      } else {
        for (int k = i; k < shipLength + i; k++) {
          cells[k][j].setValue(1);
          shipCells.add(cells[k][j]);
        }
      }
      var newShip = Ship(shipCells, isHorizontal, shipLength);
      fillSurroundings(newShip);
      return newShip;
    } else {
      return placeShip(shipLength);
    }
  }

  /// Generates two random integers until it finds a spot
  /// on the board that is empty.
  List<int> chooseInitialSpot() {
    var randI = rand.nextInt(10);
    var randJ = rand.nextInt(10);
    if (cells[randI][randJ].value == 0) {
      return [randI, randJ];
    } else {
      return chooseInitialSpot();
    }
  }

  /// If the ship fits on the board starting at the specified spot (i, j)
  /// and if there are no collisions with other ships returns true
  /// otherwise returns false;
  bool checkAvailableSpace(bool isHorizontal, int shipLength, int i, int j) {
    var shipFits = checkFit(isHorizontal, shipLength, i, j);
    if (shipFits) {
      var collisionExists = checkCollisions(isHorizontal, shipLength, i, j);
      if (!collisionExists) {
        return true;
      }
    }
    return false;
  }

  /// Checks if the ship fits on the board starting at
  /// the specified spot (i, j).
  ///
  /// Depending on the ship's orientation adds the length of
  /// the ship to the specified cell and checks if the ship
  /// fits on the board.
  bool checkFit(bool isHorizontal, int shipLength, int i, int j) {
    if (isHorizontal) {
      if (j + shipLength > 10) {
        return false;
      } else {
        return true;
      }
    } else {
      if (i + shipLength > 10) {
        return false;
      } else {
        return true;
      }
    }
  }

  /// Depending on the orientation checks for collisions with
  /// other ships starting at the chosen spot.
  ///
  /// Starts at the chosen spot and checks all of the
  /// cells that the ship's length covers.
  bool checkCollisions(bool isHorizontal, int shipLength, int i, int j) {
    if (isHorizontal) {
      for (int k = j + 1; k < shipLength + j; k++) {
        if (cells[i][k].value != 0) {
          return true;
        }
      }
    } else {
      for (int k = i + 1; k < shipLength + i; k++) {
        if (cells[k][j].value != 0) {
          return true;
        }
      }
    }
    return false;
  }

  /// Fills the area around the ship.
  void fillSurroundings(Ship ship) {
    /// Based on the ship's orientation and position (eg. ship is at the end
    /// of the board), calculates the starting and
    /// ending position of the surrounding area.
    var shipStart = ship.cells.first;
    var shipEnd = ship.cells.last;
    if (ship.isHorizontal) {
      var shipRow = ship.cells[0].i;
      var startPos = shipStart.j;
      var endPos = shipEnd.j;
      if (startPos - 1 >= 0) {
        startPos = shipStart.j - 1;
        cells[shipRow][startPos].setValue(2);
      }
      if (endPos + 1 <= 9) {
        endPos = shipEnd.j + 1;
        cells[shipRow][endPos].setValue(2);
      }

      /// Fills out all of the cells with 2's indicating that
      /// no other ships can be placed here.
      for (int k = startPos; k <= endPos; k++) {
        if (shipRow - 1 >= 0) {
          cells[shipRow - 1][k].setValue(2);
        }
        if (shipRow + 1 <= 9) {
          cells[shipRow + 1][k].setValue(2);
        }
      }
    } else {
      var shipColumn = ship.cells[0].j;
      var startPos = shipStart.i;
      var endPos = shipEnd.i;
      if (startPos - 1 >= 0) {
        startPos = shipStart.i - 1;
        cells[startPos][shipColumn].setValue(2);
      }
      if (endPos + 1 <= 9) {
        endPos = shipEnd.i + 1;
        cells[endPos][shipColumn].setValue(2);
      }
      for (int k = startPos; k <= endPos; k++) {
        if (shipColumn - 1 >= 0) {
          cells[k][shipColumn - 1].setValue(2);
        }
        if (shipColumn + 1 <= 9) {
          cells[k][shipColumn + 1].setValue(2);
        }
      }
    }
  }

  /// Checks opponents guess.
  String checkGuess(int i, int j) {
    /// If the cell value is 1 the opponent guessed correctly.
    if (cells[i][j].value == 1) {
      cells[i][j].setValue(4);

      var ship = findShip(cells[i][j]);
      var didSink = ship.takeHit();
      if (didSink) {
        ships.remove(ship);
        return "Sink";
      } else {
        return "Hit";
      }
    } else {
      cells[i][j].setValue(3);
      return "Miss";
    }
  }

  Ship findShip(Cell cell) {
    for (Ship ship in ships) {
      if (ship.cells.contains(cell)) {
        return ship;
      }
    }
    throw Exception("No ships found!");
  }
}

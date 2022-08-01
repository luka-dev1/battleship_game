import 'dart:math';

class Board {
  /// Used to generate random values.
  final rand = Random();

  /// 10 x 10 grid with all of the cells set to 0.
  /// (number 0 indicates that the cell is empty)
  var grid = List.generate(10, (i) => List<int>.generate(10, (j) => 0));

  /*void printGrid() {
    for (int i = 0; i < 10; i++) {
      print(grid[i]);
    }
  }*/

  /// Populates the board with 5 different ships.
  void populate() {
    grid = List.generate(10, (i) => List<int>.generate(10, (j) => 0));

    /// List of available ships to place.
    var ships = [2, 3, 3, 4, 5];

    for (int ship in ships) {
      /// Tries to place a ship on the board and keeps trying until successful.
      placeShip(ship);
    }
  }

  /// Places a ship on the board.
  void placeShip(int ship) {
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
    var spaceExists = checkAvailableSpace(isHorizontal, ship, i, j);
    if (spaceExists) {
      if (isHorizontal) {
        for (int k = j; k < ship + j; k++) {
          grid[i][k] = 1;
        }
        fillSurroundings(isHorizontal, i, j, ship);
      } else {
        for (int k = i; k < ship + i; k++) {
          grid[k][j] = 1;
        }
        fillSurroundings(isHorizontal, i, j, ship);
      }
    } else {
      placeShip(ship);
    }
  }

  /// Generates two random integers until it finds a spot
  /// on the board that is empty.
  List<int> chooseInitialSpot() {
    var randI = rand.nextInt(10);
    var randJ = rand.nextInt(10);
    if (grid[randI][randJ] == 0) {
      return [randI, randJ];
    } else {
      return chooseInitialSpot();
    }
  }

  /// If the ship fits on the board starting at the specified spot (i, j)
  /// and if there are no collisions with other ships returns true
  /// otherwise returns false;
  bool checkAvailableSpace(bool isHorizontal, int ship, int i, int j) {
    var shipFits = checkFit(isHorizontal, ship, i, j);
    if (shipFits) {
      var collisionExists = checkCollisions(isHorizontal, ship, i, j);
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
  bool checkFit(bool isHorizontal, int ship, int i, int j) {
    if (isHorizontal) {
      if (j + ship > 10) {
        return false;
      } else {
        return true;
      }
    } else {
      if (i + ship > 10) {
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
  bool checkCollisions(bool isHorizontal, int ship, int i, int j) {
    if (isHorizontal) {
      for (int k = j + 1; k < ship + j; k++) {
        if (grid[i][k] != 0) {
          return true;
        }
      }
    } else {
      for (int k = i + 1; k < ship + i; k++) {
        if (grid[k][j] != 0) {
          return true;
        }
      }
    }
    return false;
  }

  /// Fills the area around the ship.
  ///
  /// Ship's beginning is at the cell grid[i,j].
  void fillSurroundings(bool isHorizontal, int i, int j, int ship) {
    /// Based on the ship's orientation and position (eg. ship is at the end
    /// of the board), calculates the starting and
    /// ending position of the surrounding area.
    if (isHorizontal) {
      var startPos = j;
      var endPos = j + ship - 1;
      if (j - 1 >= 0) {
        startPos = j - 1;
        grid[i][startPos] = 2;
      }
      if (j + ship <= 9) {
        endPos = j + ship;
        grid[i][endPos] = 2;
      }

      /// Fills out all of the cells with 2's indicating that
      /// no other ships can be placed here.
      for (int k = startPos; k <= endPos; k++) {
        if (i - 1 >= 0) {
          grid[i - 1][k] = 2;
        }
        if (i + 1 <= 9) {
          grid[i + 1][k] = 2;
        }
      }
    } else {
      var startPos = i;
      var endPos = i + ship - 1;
      if (i - 1 >= 0) {
        startPos = i - 1;
        grid[startPos][j] = 2;
      }
      if (i + ship <= 9) {
        endPos = i + ship;
        grid[endPos][j] = 2;
      }
      for (int k = startPos; k <= endPos; k++) {
        if (j - 1 >= 0) {
          grid[k][j - 1] = 2;
        }
        if (j + 1 <= 9) {
          grid[k][j + 1] = 2;
        }
      }
    }
  }

  /// Fills the area around the ship.
  ///
  /// We DON'T know the ship's beginning cell.
  void fillSurroundingsTwo(bool isHorizontal, int i, int j) {
    /// Calculates the starting and ending position of the ship.
    var startPos = findStart(isHorizontal, i, j);
    var endPos = findEnd(isHorizontal, i, j);

    /// Fills out all of the cells with 2's indicating that
    /// no other ships can be placed here.
    if (isHorizontal) {
      grid[i][startPos] = 2;
      grid[i][endPos] = 2;
      for (int k = startPos; k <= endPos; k++) {
        if (i - 1 >= 0) {
          grid[i - 1][k] = 2;
        }
        if (i + 1 <= 9) {
          grid[i + 1][k] = 2;
        }
      }
    } else {
      grid[startPos][j] = 2;
      grid[endPos][j] = 2;
      for (int k = startPos; k <= endPos; k++) {
        if (j - 1 >= 0) {
          grid[k][j - 1] = 2;
        }
        if (j + 1 <= 9) {
          grid[k][j + 1] = 2;
        }
      }
    }
  }

  /// Calculates the start of a ship depending on the orientation.
  int findStart(bool isHorizontal, int i, int j) {
    if (isHorizontal) {
      while (j - 1 >= 0) {
        j = j - 1;
        if (grid[i][j] != 1 && grid[i][j] != 4) {
          break;
        }
      }
      return j;
    } else {
      while (i - 1 >= 0) {
        i = i - 1;
        if (grid[i][j] != 1 && grid[i][j] != 4) {
          break;
        }
      }
      return i;
    }
  }

  /// Calculates the end of a ship depending on the orientation.
  int findEnd(bool isHorizontal, int i, int j) {
    if (isHorizontal) {
      while (j + 1 <= 9) {
        j = j + 1;
        if (grid[i][j] != 1 && grid[i][j] != 4) {
          break;
        }
      }
      return j;
    } else {
      while (i + 1 <= 9) {
        i = i + 1;
        if (grid[i][j] != 1 && grid[i][j] != 4) {
          break;
        }
      }
      return i;
    }
  }

  /// Checks opponents guess.
  String checkGuess(int i, int j) {
    /// If the cell value is 1 the opponent guessed correctly.
    if (grid[i][j] == 1) {
      grid[i][j] = 4;

      /// Checks if the ship is sunk after this Hit.
      var didSink = checkIfSunk(i, j);
      if (didSink) {
        return "Sink";
      } else {
        return "Hit";
      }
    } else {
      grid[i][j] = 3;
      return "Miss";
    }
  }

  /// Checks if the ship's orientation is horizontal by
  /// checking if any of the neighbouring cells to the left
  /// or right belong to the ship.
  bool getOrientation(int i, int j) {
    if (i - 1 >= 0) {
      if (grid[i - 1][j] == 1 || grid[i - 1][j] == 4) {
        return false;
      }
    }
    if (i + 1 <= 9) {
      if (grid[i + 1][j] == 1 || grid[i + 1][j] == 4) {
        return false;
      }
    }
    return true;
  }

  /// Checks if the ship has sunk by checking if there are
  /// any cells around the ship that still have value of 1.
  ///
  /// If there is such a cell the ship is still afloat.
  bool checkIfSunk(int i, int j) {
    var isHorizontal = getOrientation(i, j);
    if (isHorizontal) {
      while (j + 1 <= 9) {
        j = j + 1;
        if (grid[i][j] == 1) {
          return false;
        } else if (grid[i][j] != 4) {
          break;
        }
      }
      while (j - 1 >= 0) {
        j = j - 1;
        if (grid[i][j] == 1) {
          return false;
        } else if (grid[i][j] != 4) {
          break;
        }
      }
    } else {
      while (i + 1 <= 9) {
        i = i + 1;
        if (grid[i][j] == 1) {
          return false;
        } else if (grid[i][j] != 4) {
          break;
        }
      }
      while (i - 1 >= 0) {
        i = i - 1;
        if (grid[i][j] == 1) {
          return false;
        } else if (grid[i][j] != 4) {
          break;
        }
      }
    }
    return true;
  }
}

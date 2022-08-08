import 'dart:math';

import 'package:battle/game/widget_board.dart';
import 'package:battle/game/widget_game_over.dart';
import 'package:battle/widgets/buttons/custom_fab_extended.dart';
import 'package:flutter/material.dart';

import '../models/player.dart';

class BattleScreen extends StatefulWidget {
  static const routeName = '/battle';
  const BattleScreen({Key? key}) : super(key: key);

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  final _rand = Random();

  /// Players.
  var playerOne = Player();
  var playerTwo = Player();

  /// Indicates if the game has started or not.
  var gameStarted = false;

  /// Indicates if the game is over.
  var gameOver = false;

  /// Speed of every turn in milliseconds.
  var speed = 1200;

  /// Indicates who's turn it is.
  late int turn;

  /// Starts a new game.
  Future<void> _beginGame() async {
    /// Randomize who's turn it is.
    turn = _rand.nextInt(2);

    gameStarted = true;

    /// Populates both players boards.
    playerOne.board.populate();
    playerTwo.board.populate();

    /// Rebuild the tree.
    setState(() {});

    /// While game is not over play turns.
    while (!gameOver) {
      await Future.delayed(
        Duration(
          milliseconds: speed,
        ),
      );
      await _playTurn();
    }
  }

  /// Plays one turn.
  Future<void> _playTurn() async {
    /// Calculates who's turn it is and whether or not somebody won.
    ///
    /// If somebody won, stops the game and declares a winner.
    switch (turn) {
      case 0:
        var didHit = playerOne.guess(playerTwo.board);
        if (didHit) {
          if (playerOne.didWin) {
            _endGame();
          }
        } else {
          turn = 1;
        }
        break;
      case 1:
        var didHit = playerTwo.guess(playerOne.board);
        if (didHit) {
          if (playerTwo.didWin) {
            _endGame();
          }
        } else {
          turn = 0;
        }
        break;
    }
    setState(() {});
  }

  void _endGame() {
    setState(() {
      gameOver = true;
    });
  }

  /// Resets everything to the beginning.
  void _restart() {
    playerOne = Player();
    playerTwo = Player();
    gameStarted = false;
    gameOver = false;
    speed = 1200;
    setState(() {});
  }

  /// Changes the speed of a turn.
  void _changeSpeed() {
    switch (speed) {
      case 1200:
        speed = 100;
        break;
      case 100:
        speed = 1200;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /// Places two boards on the screen, one for each player.
            Container(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: BoardUI(playerOne),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Expanded(
                        child: BoardUI(playerTwo),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// If the game is over shows GameOver widget
            gameOver ? GameOver(playerOne, _restart) : const SizedBox(),

            /// If the game started shows speed toggle button otherwise
            /// shows game start button.
            gameStarted
                ? !gameOver
                    ? Center(
                        child: CustomFABExtended(
                          onTap: () => _changeSpeed(),
                          padding: const EdgeInsets.all(8.0),
                          height: 30,
                          color: Colors.black,
                          label: Text(
                            speed == 1200 ? "speed up" : "slow down",
                            style: const TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox()
                : Center(
                    child: CustomFABExtended(
                      onTap: () => _beginGame(),
                      padding: const EdgeInsets.all(8.0),
                      height: 35,
                      color: Colors.black,
                      label: const Text(
                        "Start",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

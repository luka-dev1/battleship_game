import 'package:flutter/material.dart';

import '../models/player.dart';
import '../widgets/buttons/custom_fab.dart';

class GameOver extends StatelessWidget {
  final Player playerOne;
  final Function restart;

  const GameOver(this.playerOne, this.restart, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          Row(
            children: [
              const Text(
                "WINNER ",
              ),
              Icon(
                playerOne.didWin ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.black,
                size: 30,
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          CustomFAB(
            onTap: restart,
            padding: const EdgeInsets.all(8.0),
            shape: BoxShape.rectangle,
            size: 30,
            color: Colors.green,
            label: const Icon(Icons.restart_alt),
          ),
        ],
      ),
    );
  }
}

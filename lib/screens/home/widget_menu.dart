import 'package:battle/game/screen_battle.dart';
import 'package:flutter/material.dart';

import '../../widgets/buttons/button_big.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Play",
          style: TextStyle(
            fontFamily: 'PressStart2P',
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        BigButton(
          onTap: () => Navigator.of(context).pushNamed(BattleScreen.routeName),
          padding: const EdgeInsets.all(15.0),
          height: 50,
          width: 150,
          color: Colors.green,
          label: const Text(
            "Simulation",
            style: TextStyle(
              fontFamily: 'PressStart2P',
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        BigButton(
          onTap: () {},
          padding: const EdgeInsets.all(18.0),
          height: 50,
          width: 150,
          color: Colors.green,
          label: const Text(
            "vs AI",
            style: TextStyle(
              fontFamily: 'PressStart2P',
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

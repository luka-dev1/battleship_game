import 'package:battle/game/screen_battle.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battleships',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: BattleScreen.routeName,
      routes: {
        BattleScreen.routeName: (ctx) => const BattleScreen(),
      },
    );
  }
}

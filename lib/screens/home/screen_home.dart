import 'package:battle/screens/home/widget_header.dart';
import 'package:battle/screens/home/widget_menu.dart';
import 'package:battle/widgets/buttons/button_big.dart';
import 'package:battle/widgets/buttons/custom_fab_extended.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromRGBO(0, 210, 250, 1.0),
              Color.fromRGBO(58, 152, 213, 1.0),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Header(),
                ),
                const Flexible(
                  flex: 8,
                  fit: FlexFit.tight,
                  child: Center(
                    child: MainMenu(),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

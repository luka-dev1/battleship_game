import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            "BATTLESHIPS!",
            style: TextStyle(
              fontFamily: 'PressStart2P',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

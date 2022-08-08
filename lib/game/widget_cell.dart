import 'package:flutter/material.dart';

class CellUI extends StatefulWidget {
  const CellUI({Key? key}) : super(key: key);

  @override
  State<CellUI> createState() => _CellUIState();
}

class _CellUIState extends State<CellUI> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.5),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/player.dart';

class BoardUI extends StatelessWidget {
  final Player player;

  const BoardUI(this.player, {Key? key}) : super(key: key);

  Widget _buildGrid(BuildContext context, int index) {
    int gridStateLength = 10;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GridTile(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.5),
        ),
        child: Center(
          child: _buildGridItem(player, x, y),
        ),
      ),
    );
  }

  Widget _buildGridItem(Player player, int x, int y) {
    switch (player.board.cells[x][y].value) {
      case 0:
        return const Text('');
      case 1:
        return Container(
          color: Colors.blueGrey,
        );
      case 2:
        return const Text('');
      case 3:
        return const Text('X');
      case 4:
        return Container(
          color: Colors.blueGrey,
          child: const Center(
            child: Text(
              "X",
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
      default:
        return Text(player.board.cells[x][y].value.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        //padding: const EdgeInsets.all(2.0),
        //margin: const EdgeInsets.all(2.0),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 2.0)),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 10,
          ),
          itemBuilder: _buildGrid,
          itemCount: 10 * 10,
        ),
      ),
    );
  }
}

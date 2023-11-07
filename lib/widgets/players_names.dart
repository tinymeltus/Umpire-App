import 'package:flutter/material.dart';

class PlayerNameWidget extends StatelessWidget {
  final String playerName;

  const PlayerNameWidget({
    required this.playerName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      width: 150, // Specify the desired width for the player name box
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              playerName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SetScoresWidget extends StatelessWidget {
  final String playerName;
  final int gamesWon;

  SetScoresWidget({required this.playerName, required this.gamesWon});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Games Won by $playerName: $gamesWon',
      style: const TextStyle(fontSize: 18, color: Colors.greenAccent),
    );
  }
}

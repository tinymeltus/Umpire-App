import 'package:flutter/material.dart';

class SetScoresWidget extends StatelessWidget {
  final String playerName;
  final int setsWon;

  const SetScoresWidget({
    required this.playerName,
    required this.setsWon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
        alignment: Alignment.center,
        child: Text(
          '$setsWon',
          style: const TextStyle(
            fontSize: 18,
            backgroundColor: Colors.greenAccent,
          ),
        ),
      
    );
  }
}

import 'package:flutter/material.dart';

class GameSetScoresWidget extends StatelessWidget {
  final int setNumber;
  final int scorePlayerA;
  final int scorePlayerB;

  const GameSetScoresWidget({
    super.key,
    required this.setNumber,
    required this.scorePlayerA,
    required this.scorePlayerB,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            'Set $setNumber: $scorePlayerA', // Display the set number
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        // Display set scores, game scores, etc.
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            'Set $setNumber: $scorePlayerB', // Display the set number
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

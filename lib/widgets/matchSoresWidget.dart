import 'package:flutter/material.dart';

import 'GameSetScoresWidget.dart';

class MatchScoresWidget extends StatefulWidget {
  final int numberOfSets; // Number of sets in the match
  final String teamAName;
  final String teamBName;

  MatchScoresWidget({
    required this.numberOfSets,
    required this.teamAName,
    required this.teamBName,
  });

  @override
  _MatchScoresWidgetState createState() => _MatchScoresWidgetState();
}

class _MatchScoresWidgetState extends State<MatchScoresWidget> {
  // Initialize variables to hold the scores
  int scorePlayerA = 0;
  int scorePlayerB = 0;
  List<List<int>> setScores = [];

  @override
  void initState() {
    super.initState();

    // Initialize setScores with empty scores for each set
    for (int i = 0; i < widget.numberOfSets; i++) {
      setScores.add([0, 0]); // [Player A's score, Player B's score]
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Display player names, match points, and set scores
        // ...

        // Example: Display the scores for each set
        for (int setNumber = 0; setNumber < widget.numberOfSets; setNumber++)
          GameSetScoresWidget(
            setNumber: setNumber + 1, // Adjust set number (1-based)
            scorePlayerA: setScores[setNumber][0],
            scorePlayerB: setScores[setNumber][1],
          ),

        // Display other widgets as needed
      ],
    );
  }

  // Implement methods to update scores when buttons are pressed
  // ...

  // Implement methods to calculate and update game and set scores
  // ...
}

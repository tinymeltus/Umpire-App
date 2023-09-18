import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_umpire_app/model/MatchDetails.dart';

import '../widgets/matchSoresWidget.dart';
import '../widgets/GameSetScoresWidget.dart';

class MatchScoresScreen extends StatefulWidget {
  const MatchScoresScreen({
    super.key,
    required this.matchDetails,
    required this.numberOfSets,
    required this.teamAName,
    required this.teamBName,
  });

  //variables
  final MatchDetails matchDetails;
  final int numberOfSets; // Pass the number of sets as an argument
  final String teamAName;
  final String teamBName;

  @override
  State<MatchScoresScreen> createState() => _MatchScoresScreenState();
}

class _MatchScoresScreenState extends State<MatchScoresScreen> {
  int scorePlayerA = 0;
  int scorePlayerB = 0;

  int gamesPlayerA = 0;
  int gamesPlayerB = 0;

  int setsWonPlayerA = 0; // Declare setsWonPlayerA
  int setsWonPlayerB = 0; // Declare setsWonPlayerB

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text('Match Scores'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          //player names
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  widget.matchDetails
                                      .teamAName, // display player name
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Divider(
                                thickness: 2,
                                color: Colors.black,
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  widget.matchDetails
                                      .teamBName, // display player name
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            // children: MatchScoresWidget(
                            //   numberOfSets: widget.numberOfSets,
                            //   teamAName: widget.teamAName,
                            //   teamBName: widget.teamBName,
                            // ),
                          ),
                          // Add more set scores here
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  '${widget.matchDetails.teamAName}:  ${_getTennisScore(scorePlayerA)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  '${widget.matchDetails.teamBName}:  ${_getTennisScore(scorePlayerB)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(thickness: 2),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _incrementScore('A');
                      },
                      child: Text('Point A'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _incrementScore('B');
                      },
                      child: Text('Point B'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Update game logic
                        Navigator.pop(context);
                      },
                      child: const Text('Game'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Update set logic
                      },
                      child: const Text('Set'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Start Tiebreak logic
                      },
                      child: const Text('Tiebreak'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Undo logic
                      },
                      child: const Text('Undo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Positioned(
              top: 05,
              right: 10,
              child: Text('Game Time: 15:30', style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  //set scores Layout,
  List<Widget> _generateSetScoresColumns(int numberOfSets) {
    List<Widget> columns = [];
    for (int set = 1; set <= numberOfSets; set++) {
      columns.add(
        Column(
          children: [
            SetScoresWidget(
              setNumber: set,
              scorePlayerA: setsWonPlayerA,
              scorePlayerB: setsWonPlayerB,
            ),
            const SizedBox(height: 10), // Adjust as needed
          ],
        ),
      );
    }
    return columns;
  }

  //scores increament method
  void _incrementScore(String player) {
    if (player == 'A') {
      scorePlayerA++;
    } else if (player == 'B') {
      scorePlayerB++;
    }

    // Check for a game win
    if (scorePlayerA >= 4 && (scorePlayerA - scorePlayerB) >= 2) {
      gamesPlayerA++;
      scorePlayerA = 0;
      scorePlayerB = 0; // Reset the scores to zero after a game win
    } else if (scorePlayerB >= 4 && (scorePlayerB - scorePlayerA) >= 2) {
      gamesPlayerB++;
      scorePlayerA = 0;
      scorePlayerB = 0; // Reset the scores to zero after a game win
    }

    // Check for a set win
    if (gamesPlayerA == widget.matchDetails.numberOfSets) {
      setsWonPlayerA++;
      gamesPlayerA = 0;
      gamesPlayerB = 0;
    } else if (gamesPlayerB == widget.matchDetails.numberOfSets) {
      setsWonPlayerB++;
      gamesPlayerA = 0;
      gamesPlayerB = 0;
    }

    setState(() {});
  }

  //display actual scores
  String _getTennisScore(int score) {
    if (score == 0) {
      return "0";
    } else if (score == 1) {
      return "15";
    } else if (score == 2) {
      return "30";
    } else if (score == 3) {
      return "40";
    } else if (score == 4) {
      return "Game";
    } else {
      return "Unknown";
    }
  }
}

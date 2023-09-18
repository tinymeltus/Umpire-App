import 'package:flutter/material.dart';
import 'package:the_umpire_app/widgets/set_scores.dart';

import '../model/MatchDetails.dart';
import '../widgets/current_game_score.dart';
import '../widgets/GameSetScoresWidget.dart';
import '../widgets/players_names.dart';

class MatchScoresScreen extends StatefulWidget {
  const MatchScoresScreen({
    Key? key,
    required this.matchDetails,
    required this.numberOfSets,
    required this.teamAName,
    required this.teamBName,
  }) : super(key: key);

  final MatchDetails matchDetails;
  final int numberOfSets;
  final String teamAName;
  final String teamBName;

  @override
  _MatchScoresScreenState createState() => _MatchScoresScreenState();
}

class _MatchScoresScreenState extends State<MatchScoresScreen> {
  // Variables,
  //gameScores
  int scorePlayerA = 0;
  int scorePlayerB = 0;

  int gamesPlayerA = 0; // Declare setsWonPlayerA
  int gamesPlayerB = 0; // Declare setsWonPlayerB

  int gamesWonPlayerA = 0;
  int gamesWonPlayerB = 0;

  bool advantagePlayerA = false;
  bool advantagePlayerB = false;

  int setsWonPlayerA = 0;
  int setsWonPlayerB = 0;

  // Add these two variables to track games won per set
  int gamesWonByPlayerAInSet = 0;
  int gamesWonByPlayerBInSet = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Scores'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  PlayerNameWidget(playerName: widget.teamAName),
                  SetScoresWidget(
                      playerName: widget.teamAName,
                      gamesWon: gamesWonByPlayerAInSet),
                  GameScoreWidget(score: scorePlayerA),
                ],
              ),
              Row(
                children: [
                  PlayerNameWidget(playerName: widget.teamBName),
                  SetScoresWidget(
                      playerName: widget.teamBName,
                      gamesWon: gamesWonByPlayerAInSet),
                  GameScoreWidget(score: scorePlayerB),
                ],
              ),

              // Other widgets can be added here...
            ],
          ),

          // buttons
          Positioned(
            bottom: 0,
            child: Row(
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
          ),
          // Timer
          Positioned(
            top: 0,
            right: 0,
            child: Text('Game Time: 15:30'),
          ),
        ],
      ),
    );
  }

  //methods
  //count game scores
  //scoring rules with duece situation included
  void _incrementScore(String player) {
    if (player == 'A') {
      if (scorePlayerA == 0) {
        scorePlayerA = 15;
      } else if (scorePlayerA == 15) {
        scorePlayerA = 30;
      } else if (scorePlayerA == 30) {
        scorePlayerA = 40;
      } else if (scorePlayerA == 40) {
        if (scorePlayerB == 40) {
          // Scores are tied at "deuce," increment by "Advantage" for Player A
          scorePlayerA = 45; // "45" means "Advantage" for Player A
          scorePlayerB = 40; // Reset Player B's score from 40 to 40
        } else if (scorePlayerB == 45) {
          // Player B had "Advantage," scores are back to "deuce"
          scorePlayerA = 40;
          scorePlayerB = 40;
        } else {
          // Player A wins the game
          gamesPlayerA++; // Increment game count for Player A
          scorePlayerA = 0; // Reset game score for Player A
          scorePlayerB = 0; // Reset game score for Player B
          // Check if a player has won the set
          if (gamesWonByPlayerAInSet ==
              widget.matchDetails.numberOfGamesPerSet) {
            setsWonPlayerA++; // Increment sets won by Player A
            gamesWonByPlayerAInSet =
                0; // Reset games won by Player A in the set
            gamesWonByPlayerBInSet =
                0; // Reset games won by Player B in the set
          }
        }
      } else if (scorePlayerA == 45) {
        // Player A has "Advantage"
        scorePlayerA = 50; // "50" means "Game Point" for Player A
      } else if (scorePlayerA == 50) {
        // Player A wins the game
        gamesPlayerA++; // Increment game count for Player A
        scorePlayerA = 0; // Reset game score for Player A
        scorePlayerB = 0; // Reset game score for Player B
        // Check if a player has won the set
        if (gamesWonByPlayerAInSet == widget.matchDetails.numberOfGamesPerSet) {
          setsWonPlayerA++; // Increment sets won by Player A
          gamesWonByPlayerAInSet = 0; // Reset games won by Player A in the set
          gamesWonByPlayerBInSet = 0; // Reset games won by Player B in the set
        }
      } else {
        // Handle other cases or show an error message
      }
    } else if (player == 'B') {
      if (scorePlayerB == 0) {
        scorePlayerB = 15;
      } else if (scorePlayerB == 15) {
        scorePlayerB = 30;
      } else if (scorePlayerB == 30) {
        scorePlayerB = 40;
      } else if (scorePlayerB == 40) {
        if (scorePlayerA == 40) {
          // Scores are tied at "deuce," increment by "Advantage" for Player B
          scorePlayerB = 45; // "45" means "Advantage" for Player B
          scorePlayerA = 40; // Reset Player A's score from 40 to 40
        } else if (scorePlayerA == 45) {
          // Player A had "Advantage," scores are back to "deuce"
          scorePlayerA = 40;
          scorePlayerB = 40;
        } else {
          // Player B wins the game
          gamesPlayerB++; // Increment game count for Player B
          scorePlayerA = 0; // Reset game score for Player A
          scorePlayerB = 0; // Reset game score for Player B
          // Check if a player has won the set
          if (gamesWonByPlayerBInSet ==
              widget.matchDetails.numberOfGamesPerSet) {
            setsWonPlayerB++; // Increment sets won by Player A
            gamesWonByPlayerAInSet =
                0; // Reset games won by Player A in the set
            gamesWonByPlayerBInSet =
                0; // Reset games won by Player B in the set
          }
        }
      } else if (scorePlayerB == 45) {
        // Player B has "Advantage"
        scorePlayerB = 50; // "50" means "Game Point" for Player B
      } else if (scorePlayerB == 50) {
        // Player B wins the game
        gamesPlayerB++; // Increment game count for Player B
        scorePlayerA = 0; // Reset game score for Player A
        scorePlayerB = 0; // Reset game score for Player B
        // Check if a player has won the set
        if (gamesWonByPlayerAInSet == widget.matchDetails.numberOfGamesPerSet) {
          setsWonPlayerA++; // Increment sets won by Player A
          gamesWonByPlayerAInSet = 0; // Reset games won by Player A in the set
          gamesWonByPlayerBInSet = 0; // Reset games won by Player B in the set
        }
      } else {
        // Handle other cases or show an error message
      }
    }

    setState(() {});
  }

  //
  String getTennisScore(int score) {
    if (score == 0) {
      return "0";
    } else if (score == 15) {
      return "15";
    } else if (score == 30) {
      return "30";
    } else if (score == 40) {
      return "40";
    } else if (score == 45) {
      return "AD";
    } else if (score == 50) {
      return "Game";
    } else {
      return "Unknown";
    }
  }
}

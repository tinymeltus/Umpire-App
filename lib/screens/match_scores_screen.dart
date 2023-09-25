import 'package:flutter/material.dart';
import 'package:the_umpire_app/widgets/set_scores.dart';

import '../model/MatchDetails.dart';
import '../model/ScoreHistory.dart';
import '../widgets/current_game_score.dart';
import '../widgets/players_names.dart';
import '../widgets/timer_widget.dart';

class MatchScoresScreen extends StatefulWidget {
  MatchScoresScreen({
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

  // Declare scoreChangeHistory List
  final List<ScoreChangeEvent> scoreChangeHistory = [];

  @override
  _MatchScoresScreenState createState() => _MatchScoresScreenState();
}

class _MatchScoresScreenState extends State<MatchScoresScreen> {
  // Variables,
  //gameScores
  int scorePlayerA = 0;
  int scorePlayerB = 0;
  int gamesPlayerA = 0;
  int gamesPlayerB = 0;
  int setsWonPlayerA = 0;
  int setsWonPlayerB = 0;
  int numberOfSetsToWinMatch = 3; // TODO: change to dynamic value
  String matchWinner = '';
  bool isDeuce = false;

  // Variables for tracking games won per set
  int gamesWonByPlayerAInSet = 0;
  int gamesWonByPlayerBInSet = 0;

  List<List<int>> setScores = [];

  GameTimer _gameTimer = GameTimer();

  @override
  void initState() {
    super.initState();
    _gameTimer.startTimer();
  }

  @override
  void dispose() {
    _gameTimer.dispose(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

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
              Expanded(
                child: ListView.builder(
                  itemCount: setScores.length,
                  itemBuilder: (context, index) {
                    final setScore = setScores[index];
                    final setNumber = index + 1;

                    return Text(
                        'Set $setNumber: ${setScore[0]} - ${setScore[1]}');
                  },
                ),
              )
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
                    print(scorePlayerA);
                  },
                  child: Text('Point A'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _incrementScore('B');
                    print(scorePlayerB);
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
                    if (widget.scoreChangeHistory.isNotEmpty) {
                      final lastChange = widget.scoreChangeHistory.removeLast();
                      setState(() {
                        scorePlayerA = lastChange.previousScorePlayerA;
                        scorePlayerB = lastChange.previousScorePlayerB;
                      });
                    }
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
            child: StreamBuilder<int>(
              stream: _gameTimer.timerStream, // Use the timerStream
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final seconds = snapshot.data;

                  // Convert seconds into a formatted time string (you can use your own format)
                  final minutes = seconds! ~/ 60;
                  final remainingSeconds = seconds % 60;
                  final timeString =
                      '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';

                  return Text('Game Time: $timeString');
                } else {
                  return Text('Game Time: 00:00'); // Initial value
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  //methods
  //count game scores
  //scoring rules with duece situation included
 void _incrementScore(String player) {
  final lastChange = ScoreChangeEvent(scorePlayerA, scorePlayerB);
  widget.scoreChangeHistory.add(lastChange);

  if (player == 'A') {
    _handleScoringForPlayerA();
  } else if (player == 'B') {
    _handleScoringForPlayerB();
  }

  setState(() {});
}

void _handleScoringForPlayerA() {
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
      isDeuce = true;
    } else if (scorePlayerB == 45) {
      // Player B had "Advantage," scores are back to "deuce"
      scorePlayerA = 40;
      scorePlayerB = 40;
      isDeuce = true;
    } else {
      // Player A wins the game
      gamesPlayerA++; // Increment game count for Player A
      scorePlayerA = 0; // Reset game score for Player A
      scorePlayerB = 0; // Reset game score for Player B
    }
  } else if (scorePlayerA == 45) {
    // Player A has "Advantage"
    scorePlayerA = 50; // "50" means "Game Point" for Player A
  } else if (scorePlayerA == 50) {
    // Player A wins the game
    gamesPlayerA++; // Increment game count for Player A
    scorePlayerA = 0; // Reset game score for Player A
    scorePlayerB = 0; // Reset game score for Player B
  } else {
    // Handle other cases or show an error message
  }
}

void _handleScoringForPlayerB() {
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
      isDeuce = true;
    } else if (scorePlayerA == 45) {
      // Player A had "Advantage," scores are back to "deuce"
      scorePlayerA = 40;
      scorePlayerB = 40;
      isDeuce = true;
    } else {
      // Player B wins the game
      gamesPlayerB++; // Increment game count for Player B
      scorePlayerA = 0; // Reset game score for Player A
      scorePlayerB = 0; // Reset game score for Player B
    }
  } else if (scorePlayerB == 45) {
    // Player B has "Advantage"
    scorePlayerB = 50; // "50" means "Game Point" for Player B
  } else if (scorePlayerB == 50) {
    // Player B wins the game
    gamesPlayerB++; // Increment game count for Player B
    scorePlayerA = 0; // Reset game score for Player A
    scorePlayerB = 0; // Reset game score for Player B
  } else {
    // Handle other cases or show an error message
  }
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

  // Check for game winner and update gamesPlayerA or gamesPlayerB
// Reset game scores to deuce (40-40) when applicable
  void _checkGameWinner() {
    if (scorePlayerA == 40 && scorePlayerB == 40) {
      // Both players are at 40-40, indicating a "deuce" situation
      // Handle deuce logic here, for example:
      // This code sets both players' scores back to 40-40
      scorePlayerA = 40;
      scorePlayerB = 40;
    } else if (scorePlayerA == 45) {
      // Player A has "Advantage"
      // Handle advantage logic here, for example:
      // Player A wins the game
      gamesPlayerA++; // Increment game count for Player A
      scorePlayerA = 0; // Reset game score for Player A
      scorePlayerB = 0; // Reset game score for Player B
    } else if (scorePlayerB == 45) {
      // Player B has "Advantage"
      // Handle advantage logic here, for example:
      // Player B wins the game
      gamesPlayerB++; // Increment game count for Player B
      scorePlayerA = 0; // Reset game score for Player A
      scorePlayerB = 0; // Reset game score for Player B
    } else {
      // Handle other game-winning conditions
      // For example, if none of the above conditions are met,
      // you can consider it a normal game win for one of the players
      if (scorePlayerA == 50) {
        // Player A wins the game
        gamesPlayerA++; // Increment game count for Player A
        scorePlayerA = 0; // Reset game score for Player A
        scorePlayerB = 0; // Reset game score for Player B
      } else if (scorePlayerB == 50) {
        // Player B wins the game
        gamesPlayerB++; // Increment game count for Player B
        scorePlayerA = 0; // Reset game score for Player A
        scorePlayerB = 0; // Reset game score for Player B
      }
    }
  }

  // Check for set winner and update setsPlayerA or setsPlayerB
  // Reset game scores and gamesPlayerA/gamesPlayerB to deuce (40-40) when applicable
  void _checkSetWinner() {
    if (gamesPlayerA == widget.matchDetails.numberOfGamesPerSet ||
        gamesPlayerB == widget.matchDetails.numberOfGamesPerSet) {
      // Reset game scores to deuce (40-40)
      scorePlayerA = 40;
      scorePlayerB = 40;

      // Add the scores to the setScores list
      setScores.add([gamesPlayerA, gamesPlayerB]);

      // Reset games won
      gamesPlayerA = 0;
      gamesPlayerB = 0;

      // Increment sets won
      if (gamesWonByPlayerAInSet > gamesWonByPlayerBInSet) {
        setsWonPlayerA++;
      } else {
        setsWonPlayerB++;
      }
    }
  }

// Check for match winner
  void _checkMatchWinner() {
    if (setsWonPlayerA == numberOfSetsToWinMatch) {
      matchWinner = 'A'; // Player A wins the match
    } else if (setsWonPlayerB == numberOfSetsToWinMatch) {
      matchWinner = 'B'; // Player B wins the match
    }
  }
}

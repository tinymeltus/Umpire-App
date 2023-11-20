import 'package:flutter/material.dart';

import '../model/MatchDetails.dart';
import '../model/ScoreHistory.dart';
import '../widgets/current_game_score.dart';
import '../widgets/players_names.dart';
import '../widgets/timer_widget.dart';
import 'package:flutter/services.dart';

class FirstToScoring extends StatefulWidget {
  FirstToScoring({
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
  State<FirstToScoring> createState() => _FirstToScoringState();
}

class _FirstToScoringState extends State<FirstToScoring> {
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

  List<List<int>> setScores = [];

  GameTimer _gameTimer = GameTimer();

  @override
  void initState() {
    super.initState();
    _gameTimer.startTimer();
  }

  @override
  void dispose() {
    // Reset preferred orientations to allow any orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // potrait screen orientation
    return Builder(builder: (context) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
      ]);
      return Scaffold(
        appBar: AppBar(
          title: const Text('First-To Game'),
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PlayerNameWidget(playerName: widget.teamAName),
                    const SizedBox(
                      width: 10,
                    ),
                    GameScoreWidget(score: scorePlayerA),
                    SizedBox(width: 20),
                    //games won widget
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$gamesPlayerA',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PlayerNameWidget(playerName: widget.teamBName),
                    const SizedBox(
                      width: 10,
                    ),
                    GameScoreWidget(score: scorePlayerB),
                    SizedBox(width: 20),
                    //games won widget
                    Container(
                      width: 50,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$gamesPlayerB',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
              bottom: 0, left: 60,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10,left:10 ),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _incrementScore('A');
                        print(scorePlayerA);
                        _checkGameWinner();
                      },
                      child: Text('Point A'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _incrementScore('B');
                        print(scorePlayerB);
                        _checkGameWinner();
                      },
                      child: Text('Point B'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Update game logic
                        Navigator.pop(context);
                      },
                      child: const Text('Game'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Update set logic
                      },
                      child: const Text('Set'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Start Tiebreak logic
                      },
                      child: const Text('Tiebreak'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (widget.scoreChangeHistory.isNotEmpty) {
                          final lastChange =
                              widget.scoreChangeHistory.removeLast();
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
    });
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
    print(
        'Before scoring: Player A score: $scorePlayerA, Player B score: $scorePlayerB');

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
        print('Advantage for Player A');
      } else if (scorePlayerB == 45) {
        // Player B had "Advantage," scores are back to "deuce"
        scorePlayerA = 40;
        scorePlayerB = 40;
        isDeuce = true;
        print('Back to deuce');
      } else {
        // Player A wins the game
        gamesPlayerA++; // Increment game count for Player A
        scorePlayerA = 0; // Reset game score for Player A
        scorePlayerB = 0; // Reset game score for Player B
        print('Player A wins the game');
      }
    } else if (scorePlayerA == 45) {
      // Player A has "Advantage"
      scorePlayerA = 50; // "50" means "Game Point" for Player A
      print('Game Point for Player A');
    } else if (scorePlayerA == 50) {
      // Player A wins the game
      gamesPlayerA++; // Increment game count for Player A
      scorePlayerA = 0; // Reset game score for Player A
      scorePlayerB = 0; // Reset game score for Player B
      print('Player A wins the game');
    } else {
      // Handle other cases or show an error message
      print('Unknown case');
    }

    print(
        'After scoring: Player A score: $scorePlayerA, Player B score: $scorePlayerB');
  }

  void _handleScoringForPlayerB() {
    print(
        'Before scoring: Player A score: $scorePlayerA, Player B score: $scorePlayerB');

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
        print('Advantage for Player B');
      } else if (scorePlayerA == 45) {
        // Player A had "Advantage," scores are back to "deuce"
        scorePlayerA = 40;
        scorePlayerB = 40;
        isDeuce = true;
        print('Back to deuce');
      } else {
        // Player B wins the game
        gamesPlayerB++; // Increment game count for Player B
        scorePlayerA = 0; // Reset game score for Player A
        scorePlayerB = 0; // Reset game score for Player B
        print('Player B wins the game');
      }
    } else if (scorePlayerB == 45) {
      // Player B has "Advantage"
      scorePlayerB = 50; // "50" means "Game Point" for Player B
      print('Game Point for Player B');
    } else if (scorePlayerB == 50) {
      // Player B wins the game
      gamesPlayerB++; // Increment game count for Player B
      scorePlayerA = 0; // Reset game score for Player A
      scorePlayerB = 0; // Reset game score for Player B
      print('Player B wins the game');
    } else {
      // Handle other cases or show an error message
      print('Unknown case');
    }

    print(
        'After scoring: Player A score: $scorePlayerA, Player B score: $scorePlayerB');
  }

  void _checkGameWinner() {
    if (gamesPlayerA >= widget.matchDetails.numberOfGamesPerSet ||
        gamesPlayerB >= widget.matchDetails.numberOfGamesPerSet) {
      // Check if the game is won by Player A
      if (gamesPlayerA >= widget.matchDetails.numberOfGamesPerSet &&
          gamesPlayerA - gamesPlayerB >= 2) {
        print('Game over! ${widget.teamAName} wins the Match!');
        // Declare winner and reset scores
        gamesPlayerA = 0;
        gamesPlayerB = 0;
      }
      // Check if the game is won by Player B
      else if (gamesPlayerB >= widget.matchDetails.numberOfGamesPerSet &&
          gamesPlayerB - gamesPlayerA >= 2) {
        print('Game over! ${widget.teamBName} wins the Match!');
        // Declare winner and reset scores
        gamesPlayerA = 0;
        gamesPlayerB = 0;
      }
    }
  }
}

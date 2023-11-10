import 'package:flutter/material.dart';
import 'package:the_umpire_app/screens/match_scores_screen.dart';

import '../model/MatchDetails.dart';
import '../screens/first_to_scoring_screen.dart';

class MatchDetailsDialog extends StatefulWidget {
  const MatchDetailsDialog({Key? key, required this.matchType})
      : super(key: key);

  final int matchType;

  @override
  State<MatchDetailsDialog> createState() => _MatchDetailsDialogState();
}

class _MatchDetailsDialogState extends State<MatchDetailsDialog> {
  //variables
  bool _isSingles = true; //Default game type
  TextEditingController teamANameController = TextEditingController();
  TextEditingController teamBNameController = TextEditingController();
  TextEditingController numberOfSetsController =
      TextEditingController(); // also counts number of games in first-to games

  int numberOfGamesPerSet = 0;

  @override
  void dispose() {
    teamANameController.dispose();
    teamBNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Match Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Select Game Type:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Switch(
                value: _isSingles,
                autofocus: true,
                onChanged: (bool value) {
                  //TODO: show game type
                  setState(() {
                    _isSingles = value;
                    print(_isSingles == true
                        ? 'Singles selected'
                        : 'Doubles Selected');
                  });
                },
              ),
              Text(_isSingles == true ? 'Singles' : 'Doubles'),
            ],
          ),
          TextFormField(
            controller: teamANameController,
            decoration: InputDecoration(
                labelText: _isSingles == true ? 'Player 1' : 'Team A'),
          ),
          TextFormField(
            controller: teamBNameController,
            decoration: InputDecoration(
                labelText: _isSingles == true ? 'Player 2' : 'Team B'),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: numberOfSetsController,
            decoration: InputDecoration(
              labelText: widget.matchType == 1
                  ? 'Games to be Played'
                  : 'Sets to be Played',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Start match logic
            numberOfGamesPerSet = int.parse(numberOfSetsController.text.trim());
            print(numberOfGamesPerSet);
            Navigator.pop(context); // Close the dialog
            _startMatch(context);
          },
          child: const Text('Start'),
        ),
      ],
    );
  }

  //methods
  //passing player names
  void _startMatch(BuildContext context) {
    // Get the text from the controllers
    String teamAName = teamANameController.text.trim();
    String teamBName = teamBNameController.text.trim();
    String numberOfSetsText = numberOfSetsController.text.trim();

    // Check if any of the fields are empty
    if (teamAName.isEmpty || teamBName.isEmpty || numberOfSetsText.isEmpty) {
      // Show a snackbar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
          duration: Duration(seconds: 3),
        ),
      );
    } else if (int.tryParse(numberOfSetsText) == null) {
      // Show a snackbar with an error message for non-numeric input
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Number of Sets must be a valid number.'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      // All fields are filled and the number of sets is valid, proceed to start the whichever match selected
      int numberOfSets = int.parse(numberOfSetsText);

      MatchDetails matchDetails = MatchDetails(
        teamAName: teamAName,
        teamBName: teamBName,
        numberOfSets: numberOfSets,
        numberOfGamesPerSet: numberOfGamesPerSet,
      );
      if (widget.matchType == 1) {
        // Navigate to FirstToScoringScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FirstToScoring(
              matchDetails: matchDetails,
              numberOfSets: numberOfSets,
              teamAName: teamAName,
              teamBName: teamBName,
            ),
          ),
        );
      } else if (widget.matchType == 2) {
        // Navigate to MatchScoresScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchScoresScreen(
              matchDetails: matchDetails,
              numberOfSets: numberOfSets,
              teamAName: teamAName,
              teamBName: teamBName,
            ),
          ),
        );
      }
    }
  }
}

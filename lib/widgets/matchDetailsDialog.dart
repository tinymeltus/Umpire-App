import 'package:flutter/material.dart';
import 'package:the_umpire_app/screens/match_scores_screen.dart';

import '../model/MatchDetails.dart';

class MatchDetailsDialog extends StatefulWidget {
  const MatchDetailsDialog({super.key});

  @override
  State<MatchDetailsDialog> createState() => _MatchDetailsDialogState();
}

class _MatchDetailsDialogState extends State<MatchDetailsDialog> {
  //variables
  bool _isSingles = true; //Default game type
  TextEditingController _teamANameController = TextEditingController();
  TextEditingController _teamBNameController = TextEditingController();
  TextEditingController _numberOfSetsController = TextEditingController();

  int numberOfGamesPerSet = 6;

  @override
  void dispose() {
    _teamANameController.dispose();
    _teamBNameController.dispose();
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
            controller: _teamANameController,
            decoration: InputDecoration(
                labelText: _isSingles == true ? 'Player 1' : 'Team A'),
          ),
          TextFormField(
            controller: _teamBNameController,
            decoration: InputDecoration(
                labelText: _isSingles == true ? 'Player 2' : 'Team B'),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: _numberOfSetsController,
            decoration: const InputDecoration(labelText: 'Sets to be Played'),
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
    String teamAName = _teamANameController.text.trim();
    String teamBName = _teamBNameController.text.trim();
    String numberOfSetsText = _numberOfSetsController.text.trim();

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
      // All fields are filled and the number of sets is valid, proceed to start the match
      int numberOfSets = int.parse(numberOfSetsText);

     
      MatchDetails matchDetails = MatchDetails(
        teamAName: teamAName,
        teamBName: teamBName,
        numberOfSets: numberOfSets,
        numberOfGamesPerSet : numberOfGamesPerSet,
      );

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

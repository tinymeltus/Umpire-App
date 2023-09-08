import 'package:flutter/material.dart';

import 'match_history.dart';

class MatchResultScreen extends StatelessWidget {
  final MatchRecord match;

  MatchResultScreen({required this.match});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${match.teamA} vs ${match.teamB}'),
            Text('Date: ${match.date}'),
            Text('Winner: ${match.winner}'),
            // Add more match result details here
          ],
        ),
      ),
    );
  }
}

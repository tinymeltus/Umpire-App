import 'package:flutter/material.dart';

import 'match_results.dart';

class MatchHistoryScreen extends StatelessWidget {
  const MatchHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match History'),
      ),
      body: ListView.builder(
        itemCount: matchHistory.length,
        itemBuilder: (context, index) {
          final match = matchHistory[index];
          return GestureDetector(
            child: ListTile(
              title: Text('${match.teamA} vs ${match.teamB}'),
              subtitle: Text('Date: ${match.date}'),
              trailing: Text('Winner: ${match.winner}'),
            ),
            onTap: (){
              //navigate to match result details screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MatchResultScreen(match: match)),
              );
            },
          );
        },
      ),
    );
  }
}

class MatchRecord {
  final String teamA;
  final String teamB;
  final String date;
  final String winner;

  MatchRecord({required this.teamA, required this.teamB, required this.date, required this.winner});
}

List<MatchRecord> matchHistory = [
  MatchRecord(teamA: 'Team A', teamB: 'Team B', date: '2023-08-14', winner: 'Team A'),
  MatchRecord(teamA: 'Team X', teamB: 'Team Y', date: '2023-08-13', winner: 'Team Y'),
  // Add more match records here
];

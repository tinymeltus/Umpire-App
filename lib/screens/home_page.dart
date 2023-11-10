import 'package:flutter/material.dart';
import 'package:the_umpire_app/screens/settings.dart';

import '../model/MatchDetails.dart';
import '../widgets/matchDetailsDialog.dart';
import 'match_history.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //APP bar
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Row(
          children: [
            Icon(
              Icons.home,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              'Umpire App',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      //bottom navigation bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                // Open menu or navigate to other screen
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                // Open settings or navigate to settings screen
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Perform action when FAB is pressed
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(
          Icons.add,
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              //TODO: navigate to start match
                _showMatchDetailsDialog(context, matchType: 2);
                print('normal game');
            },
            label: const Text('Start Match'),
            icon: const Icon(Icons.start),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to Match Details Dialog
                _showMatchDetailsDialog(context, matchType: 1);
                print('first-To game');
            },
            child: const Text('First Off Match'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            onPressed: () {
              //TODO navigate to start match
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MatchHistoryScreen()),
              );
            },
            icon: const Icon(Icons.history),
            label: const Text('Match History'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            onPressed: () {
              //TODO: navigate to settings
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings),
            label: const Text('Settings'),
          ),
        ],
      )),
    );
  }
}

Future<MatchDetails?> _showMatchDetailsDialog(BuildContext context, {required int matchType}) async {
  return await showDialog<MatchDetails>(
    context: context,
    builder: (BuildContext context) {
      return MatchDetailsDialog(matchType: matchType,);
    },
  );
}

import 'package:flutter/material.dart';

class PlayerNameWidget extends StatelessWidget {
  final String playerName;

  PlayerNameWidget({required this.playerName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        playerName.toUpperCase(),
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}

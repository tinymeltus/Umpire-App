import 'package:flutter/material.dart';

class GameScoreWidget extends StatelessWidget {
  final int score;

  GameScoreWidget({required this.score});

  @override
  Widget build(BuildContext context) {
    return Text(
      getTennisScore(score),
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
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

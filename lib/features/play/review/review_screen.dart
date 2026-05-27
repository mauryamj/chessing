import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  final int gameId;
  const ReviewScreen({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Review Game $gameId')),
      body: Center(
        child: Text('Review gameplay screen for game $gameId (Coming in Phase 2)'),
      ),
    );
  }
}

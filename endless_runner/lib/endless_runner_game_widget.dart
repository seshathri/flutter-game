import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'endless_runner_game.dart';

class EndlessRunnerGameWidget extends StatelessWidget {
  final EndlessRunnerGame game;
  const EndlessRunnerGameWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < 0) {
            // Swipe left
            game.switchLane(-1);
          } else if (details.primaryVelocity! > 0) {
            // Swipe right
            game.switchLane(1);
          }
        }
      },
      child: GameWidget(game: game),
    );
  }
}

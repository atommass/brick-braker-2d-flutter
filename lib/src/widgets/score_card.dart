import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard(
      {super.key,
      required this.score,
      required this.level,
      required this.lives});

  final ValueNotifier<int> score;
  final ValueNotifier<int> level;
  final ValueNotifier<int> lives;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: score,
      builder: (context, score, child) {
        return ValueListenableBuilder<int>(
          valueListenable: level,
          builder: (context, level, child) {
            return ValueListenableBuilder(
              valueListenable: lives,
              builder: (context, lives, child) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 18),
                  child: Text(
                    'Score: $score Level: $level Lives: $lives'.toUpperCase(),
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
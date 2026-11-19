import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../widgets/chunky_button.dart';
import '../widgets/speech_bubble.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.stars,
    required this.correct,
    required this.total,
    required this.dataPath,
    required this.title,
  });

  final int stars;
  final int correct;
  final int total;
  final String dataPath;
  final String title;

  void _playAgain(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => QuizScreen(dataPath: dataPath, title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                children: [
                  const SpeechBubble(text: 'Hore! Hebat!'),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Image.asset(
                      'assets/mascot/garu_cheer.png',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < 3; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.star_rounded,
                            size: 72,
                            color: i < stars
                                ? AppColors.gold
                                : AppColors.starEmpty,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('$correct dari $total benar', style: text.titleLarge),
                  const SizedBox(height: 20),
                  ChunkyButton(
                    color: AppColors.gold,
                    onTap: () => _playAgain(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.replay_rounded,
                          size: 32,
                          color: AppColors.mocha,
                        ),
                        const SizedBox(width: 8),
                        Text('Main Lagi', style: text.titleLarge),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ChunkyButton(
                    color: AppColors.mint,
                    onTap: () =>
                        Navigator.of(context).popUntil((r) => r.isFirst),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.home_rounded,
                          size: 32,
                          color: AppColors.mocha,
                        ),
                        const SizedBox(width: 8),
                        Text('Menu Utama', style: text.titleLarge),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

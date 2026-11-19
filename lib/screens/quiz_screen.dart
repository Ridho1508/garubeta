import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/question.dart';
import '../quiz_engine/quiz_controller.dart';
import '../services/quiz_repository.dart';
import '../services/sound_service.dart';
import '../widgets/chunky_button.dart';
import '../widgets/speech_bubble.dart';
import '../widgets/square_button.dart';
import 'result_screen.dart';

/// Layar kuis. Dipakai bersama oleh semua modul; bedanya cuma file soalnya.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.dataPath, required this.title});

  final String dataPath;
  final String title;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final Future<QuizController> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<QuizController> _load() async {
    final questions = await QuizRepository.load(widget.dataPath);
    return QuizController(questions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<QuizController>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Soal gagal dimuat.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }
            final controller = snapshot.data;
            if (controller == null) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              );
            }
            return _QuizBody(
              controller: controller,
              dataPath: widget.dataPath,
              title: widget.title,
            );
          },
        ),
      ),
    );
  }
}

class _QuizBody extends StatefulWidget {
  const _QuizBody({
    required this.controller,
    required this.dataPath,
    required this.title,
  });

  final QuizController controller;
  final String dataPath;
  final String title;

  @override
  State<_QuizBody> createState() => _QuizBodyState();
}

class _QuizBodyState extends State<_QuizBody> {
  QuizController get c => widget.controller;

  @override
  void initState() {
    super.initState();
    SoundService.speak(c.current.text);
  }

  void _onChoice(String id) {
    if (c.answered) return;
    final benar = c.select(id);
    if (benar) {
      SoundService.playCorrect();
    } else {
      SoundService.playWrong();
    }
  }

  void _onNext() {
    if (c.isLast) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            stars: c.stars,
            correct: c.correctCount,
            total: c.total,
            dataPath: widget.dataPath,
            title: widget.title,
          ),
        ),
      );
    } else {
      c.next();
      SoundService.speak(c.current.text);
    }
  }

  _CardMode _modeFor(Choice choice) {
    if (!c.answered) return _CardMode.normal;
    if (choice.id == c.current.correctId) {
      return c.state == AnswerState.correct
          ? _CardMode.correctPicked
          : _CardMode.correctHint;
    }
    if (choice.id == c.selectedId) return _CardMode.wrong;
    return _CardMode.normal;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: ListenableBuilder(
            listenable: c,
            builder: (context, _) {
              final q = c.current;

              final String pose;
              final String message;
              if (!c.answered) {
                pose = 'garu_think';
                message = 'Hmm, yang mana ya?';
              } else if (c.state == AnswerState.correct) {
                pose = 'garu_cheer';
                message = 'Hore, benar!';
              } else {
                pose = 'garu_encourage';
                message = 'Yang benar ini, ${q.correctChoice.label}!';
              }

              return Column(
                children: [
                  Row(
                    children: [
                      SquareButton(
                        icon: Icons.home_rounded,
                        color: AppColors.white,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StarProgress(
                          total: c.total,
                          done: c.doneCount,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SquareButton(
                        icon: Icons.volume_up_rounded,
                        color: AppColors.mint,
                        onTap: () => SoundService.speak(q.text),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _QuestionCard(text: q.text),
                  const SizedBox(height: 28),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < q.choices.length; i++) ...[
                        if (i > 0) const SizedBox(width: 12),
                        Expanded(
                          child: _ChoiceCard(
                            choice: q.choices[i],
                            mode: _modeFor(q.choices[i]),
                            onTap: () => _onChoice(q.choices[i].id),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: SpeechBubble(text: message)),
                          const SizedBox(width: 12),
                          Image.asset(
                            'assets/mascot/$pose.png',
                            height: 120,
                            filterQuality: FilterQuality.high,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 88,
                    child: c.answered
                        ? ChunkyButton(
                            color: AppColors.gold,
                            onTap: _onNext,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  c.isLast ? 'Selesai' : 'Lanjut',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 32,
                                  color: AppColors.mocha,
                                ),
                              ],
                            ),
                          )
                        : null,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StarProgress extends StatelessWidget {
  const _StarProgress({required this.total, required this.done});

  final int total;
  final int done;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.mocha, width: 3),
        boxShadow: const [
          BoxShadow(
            color: AppColors.mocha,
            offset: Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < total; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Icon(
                Icons.star_rounded,
                size: 30,
                color: i < done ? AppColors.gold : AppColors.starEmpty,
              ),
            ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.mocha, width: 3),
        boxShadow: const [
          BoxShadow(
            color: AppColors.mocha,
            offset: Offset(0, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}

enum _CardMode { normal, correctPicked, correctHint, wrong }

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.choice,
    required this.mode,
    required this.onTap,
  });

  final Choice choice;
  final _CardMode mode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color color = AppColors.white;
    Color border = AppColors.mocha;
    Widget? badge;

    switch (mode) {
      case _CardMode.normal:
        break;
      case _CardMode.correctPicked:
        color = AppColors.gold;
        badge = const _Badge(
          color: AppColors.mint,
          child: Icon(Icons.check_rounded, size: 22, color: AppColors.mocha),
        );
      case _CardMode.correctHint:
        border = AppColors.gold;
        badge = const _Badge(
          color: AppColors.gold,
          child: Text(
            'Ini dia!',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: AppColors.mocha,
            ),
          ),
        );
      case _CardMode.wrong:
        color = AppColors.coralLight;
        border = AppColors.coral;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ChunkyButton(
          color: color,
          borderColor: border,
          minHeight: 170,
          radius: 24,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 90, child: _ChoiceImage(path: choice.image)),
              const SizedBox(height: 8),
              Text(
                choice.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        if (badge != null)
          Positioned(
            top: -16,
            left: 0,
            right: 0,
            child: Center(child: badge),
          ),
      ],
    );
  }
}

class _ChoiceImage extends StatelessWidget {
  const _ChoiceImage({this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    // Kalau gambarnya belum ada, tampil ikon cakar sebagai pengganti.
    const fallback = Center(
      child: Icon(Icons.pets_rounded, size: 56, color: AppColors.gold),
    );
    final p = path;
    if (p == null) return fallback;
    return Image.asset(
      p,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) => fallback,
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mocha, width: 2.5),
      ),
      child: child,
    );
  }
}

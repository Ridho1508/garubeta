import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../widgets/chunky_button.dart';
import '../widgets/speech_bubble.dart';
import '../widgets/square_button.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _soon(BuildContext context, String nama) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Modul $nama segera hadir')));
  }

  void _openQuiz(BuildContext context, String dataPath, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(dataPath: dataPath, title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                children: [
                  const _TopBar(),
                  const SizedBox(height: 16),
                  const SpeechBubble(text: 'Halo, Teman Kecil!'),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Image.asset(
                      'assets/mascot/garu_happy.png',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ModuleCard(
                    label: 'Hewan',
                    icon: Icons.pets_rounded,
                    color: AppColors.peach,
                    onTap: () =>
                        _openQuiz(context, 'assets/data/animals.json', 'Hewan'),
                  ),
                  const SizedBox(height: 12),
                  _ModuleCard(
                    label: 'Angka',
                    icon: Icons.calculate_rounded,
                    color: AppColors.mintLight,
                    onTap: () => _soon(context, 'Angka'),
                  ),
                  const SizedBox(height: 12),
                  _ModuleCard(
                    label: 'Warna & Bentuk',
                    icon: Icons.category_rounded,
                    color: AppColors.pink,
                    onTap: () => _soon(context, 'Warna & Bentuk'),
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

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        SquareButton(
          icon: Icons.volume_up_rounded,
          color: AppColors.mint,
          onTap: () {},
        ),
        const SizedBox(width: 12),
        SquareButton(
          icon: Icons.lock_rounded,
          color: AppColors.grayLight,
          onTap: () {}, // nanti: pengaman orang tua
        ),
        const Spacer(),
        ChunkyButton(
          color: AppColors.white,
          minHeight: 64,
          radius: 24,
          shelfHeight: 4,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          onTap: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, size: 32, color: AppColors.gold),
              const SizedBox(width: 8),
              Text('24', style: text.titleLarge), // sementara angka contoh
            ],
          ),
        ),
      ],
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChunkyButton(
      color: color,
      minHeight: 92,
      padding: const EdgeInsets.fromLTRB(24, 10, 12, 10),
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.mocha, width: 3),
            ),
            child: Icon(icon, size: 40, color: AppColors.gold),
          ),
        ],
      ),
    );
  }
}

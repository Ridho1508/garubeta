import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Aplikasi anak: cukup mode tegak biar tampilan tidak kacau
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const GaruApp());
}

class GaruApp extends StatelessWidget {
  const GaruApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garu Belajar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}

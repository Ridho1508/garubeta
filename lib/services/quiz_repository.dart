import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../models/question.dart';

/// Membaca soal dari file JSON di assets.
class QuizRepository {
  QuizRepository._();

  static Future<List<Question>> load(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final random = Random();

    final questions = (json['questions'] as List)
        .map((q) => Question.fromJson(q as Map<String, dynamic>))
        .map((q) => q.shuffled(random))
        .toList();
    questions.shuffle(random);
    return questions;
  }
}

import 'package:flutter/foundation.dart';

import '../models/question.dart';

enum AnswerState { waiting, correct, wrong }

/// Mesin kuis: mengatur soal ke berapa, mengecek jawaban, dan menghitung skor.
/// Dipakai bersama oleh semua modul.
class QuizController extends ChangeNotifier {
  QuizController(this.questions);

  final List<Question> questions;

  int _index = 0;
  int _correctCount = 0;
  String? _selectedId;
  AnswerState _state = AnswerState.waiting;

  int get index => _index;
  int get total => questions.length;
  int get correctCount => _correctCount;
  Question get current => questions[_index];
  String? get selectedId => _selectedId;
  AnswerState get state => _state;
  bool get answered => _state != AnswerState.waiting;
  bool get isLast => _index == total - 1;

  /// Jumlah soal yang sudah dijawab (untuk bintang kemajuan).
  int get doneCount => _index + (answered ? 1 : 0);

  /// Bintang akhir: minimal 1 supaya anak tidak pernah dapat 0.
  int get stars {
    final rasio = correctCount / total;
    if (rasio >= 0.8) return 3;
    if (rasio >= 0.5) return 2;
    return 1;
  }

  /// Mengembalikan true kalau jawabannya benar.
  bool select(String choiceId) {
    if (answered) return false;
    _selectedId = choiceId;
    final benar = choiceId == current.correctId;
    _state = benar ? AnswerState.correct : AnswerState.wrong;
    if (benar) _correctCount++;
    notifyListeners();
    return benar;
  }

  void next() {
    if (isLast) return;
    _index++;
    _selectedId = null;
    _state = AnswerState.waiting;
    notifyListeners();
  }
}

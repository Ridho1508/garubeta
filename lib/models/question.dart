import 'dart:math';

/// Satu pilihan jawaban (misalnya gambar kucing).
class Choice {
  const Choice({required this.id, required this.label, this.image});

  final String id;
  final String label;
  final String? image; // path aset gambar, boleh kosong

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      id: json['id'] as String,
      label: json['label'] as String,
      image: json['image'] as String?,
    );
  }
}

/// Satu soal beserta pilihan jawabannya.
class Question {
  const Question({
    required this.id,
    required this.text,
    required this.choices,
    required this.correctId,
  });

  final String id;
  final String text;
  final List<Choice> choices;
  final String correctId;

  Choice get correctChoice => choices.firstWhere((c) => c.id == correctId);

  factory Question.fromJson(Map<String, dynamic> json) {
    final choices = (json['choices'] as List)
        .map((c) => Choice.fromJson(c as Map<String, dynamic>))
        .toList();
    return Question(
      id: json['id'] as String,
      text: json['text'] as String,
      choices: choices,
      correctId: json['correct'] as String,
    );
  }

  /// Salinan soal dengan urutan pilihan diacak.
  Question shuffled(Random random) {
    final acak = List<Choice>.of(choices)..shuffle(random);
    return Question(
      id: id,
      text: text,
      choices: acak,
      correctId: correctId,
    );
  }
}

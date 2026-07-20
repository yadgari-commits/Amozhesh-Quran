class QaidaUnit {
  final String text;
  final String audio;

  QaidaUnit({required this.text, required this.audio});

  factory QaidaUnit.fromJson(Map<String, dynamic> json) {
    return QaidaUnit(
      text: json['text'] as String,
      audio: json['audio'] as String,
    );
  }
}

class QaidaExample {
  final String word;
  final String audio;
  final List<QaidaUnit> units;

  QaidaExample({
    required this.word,
    required this.audio,
    this.units = const [],
  });

  factory QaidaExample.fromJson(Map<String, dynamic> json) {
    return QaidaExample(
      word: json['word'] as String,
      audio: json['audio'] as String,
      units: (json['units'] as List? ?? [])
          .map((e) => QaidaUnit.fromJson(e))
          .toList(),
    );
  }
}

class QaidaLesson {
  final int id;
  final String title;
  final String description;
  final List<QaidaExample> examples;

  QaidaLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.examples,
  });

  factory QaidaLesson.fromJson(Map<String, dynamic> json) {
    return QaidaLesson(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      examples: (json['examples'] as List)
          .map((e) => QaidaExample.fromJson(e))
          .toList(),
    );
  }
}

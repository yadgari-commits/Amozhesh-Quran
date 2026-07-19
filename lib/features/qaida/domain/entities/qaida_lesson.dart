class QaidaExample {
  final String word;
  final String audio;

  QaidaExample({required this.word, required this.audio});

  factory QaidaExample.fromJson(Map<String, dynamic> json) {
    return QaidaExample(
      word: json['word'] as String,
      audio: json['audio'] as String,
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

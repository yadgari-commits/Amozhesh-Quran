class QuranVerseModel {
  final int chapter;
  final int verse;
  final String text;

  QuranVerseModel({
    required this.chapter,
    required this.verse,
    required this.text,
  });

  factory QuranVerseModel.fromJson(Map<String, dynamic> json) {
    return QuranVerseModel(
      chapter: json['chapter'] as int,
      verse: json['verse'] as int,
      text: json['text'] as String,
    );
  }
}

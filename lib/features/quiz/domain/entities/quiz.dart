enum QuestionType {
  textToText,
  audioToText,
  textToAudio
}

class Question {
  final String id;
  final String questionText;
  final String? audioPath;
  final List<String> options;
  final int correctAnswerIndex;
  final QuestionType type;

  const Question({
    required this.id,
    required this.questionText,
    this.audioPath,
    required this.options,
    required this.correctAnswerIndex,
    required this.type,
  });
}

class Quiz {
  final String id;
  final String title;
  final String description;
  final List<Question> questions;

  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });
}

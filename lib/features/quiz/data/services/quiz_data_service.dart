import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/entities/quiz.dart';

class QuizDataService {
  Future<List<Quiz>> getQuizzes() async {
    final String response = await rootBundle.loadString('assets/data/quizzes.json');
    final data = await json.decode(response) as List;
    return data.map((q) => _mapJsonToQuiz(q)).toList();
  }

  Quiz _mapJsonToQuiz(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      questions: (json['questions'] as List).map((q) => Question(
        id: q['id'],
        questionText: q['questionText'],
        audioPath: q['audioPath'],
        options: List<String>.from(q['options']),
        correctAnswerIndex: q['correctAnswerIndex'],
        type: _parseType(q['type']),
      )).toList(),
    );
  }

  QuestionType _parseType(String type) {
    switch (type) {
      case 'audioToText': return QuestionType.audioToText;
      case 'textToAudio': return QuestionType.textToAudio;
      default: return QuestionType.textToText;
    }
  }
}

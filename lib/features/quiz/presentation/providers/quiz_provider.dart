import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/quiz.dart';

class QuizState {
  final int currentQuestionIndex;
  final int score;
  final bool isFinished;
  final List<bool?> userAnswers; // null = not answered, true = correct, false = wrong

  QuizState({
    this.currentQuestionIndex = 0,
    this.score = 0,
    this.isFinished = false,
    this.userAnswers = const [],
  });

  QuizState copyWith({
    int? currentQuestionIndex,
    int? score,
    bool? isFinished,
    List<bool?>? userAnswers,
  }) {
    return QuizState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      isFinished: isFinished ?? this.isFinished,
      userAnswers: userAnswers ?? this.userAnswers,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  final Quiz quiz;
  QuizNotifier(this.quiz) : super(QuizState(userAnswers: List.filled(quiz.questions.length, null)));

  void answerQuestion(int optionIndex) {
    if (state.isFinished) return;

    final question = quiz.questions[state.currentQuestionIndex];
    final isCorrect = optionIndex == question.correctAnswerIndex;
    
    final newUserAnswers = [...state.userAnswers];
    newUserAnswers[state.currentQuestionIndex] = isCorrect;

    final newScore = isCorrect ? state.score + 1 : state.score;
    final isLastQuestion = state.currentQuestionIndex == quiz.questions.length - 1;

    if (isLastQuestion) {
      state = state.copyWith(
        score: newScore,
        userAnswers: newUserAnswers,
        isFinished: true,
      );
    } else {
      state = state.copyWith(
        score: newScore,
        userAnswers: newUserAnswers,
        currentQuestionIndex: state.currentQuestionIndex + 1,
      );
    }
  }

  void reset() {
    state = QuizState(userAnswers: List.filled(quiz.questions.length, null));
  }
}

final quizProvider = StateNotifierProvider.family<QuizNotifier, QuizState, Quiz>((ref, quiz) {
  return QuizNotifier(quiz);
});

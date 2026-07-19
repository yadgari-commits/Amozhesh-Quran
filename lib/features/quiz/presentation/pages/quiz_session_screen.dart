import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/quiz.dart';
import '../providers/quiz_provider.dart';

class QuizSessionScreen extends ConsumerWidget {
  final Quiz quiz;
  const QuizSessionScreen({super.key, required this.quiz});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizProvider(quiz));
    final notifier = ref.read(quizProvider(quiz).notifier);

    if (state.isFinished) {
      return _buildResults(context, state, notifier);
    }

    final question = quiz.questions[state.currentQuestionIndex];
    final progress = (state.currentQuestionIndex + 1) / quiz.questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Question ${state.currentQuestionIndex + 1} of ${quiz.questions.length}",
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            FadeInDown(
              key: ValueKey(state.currentQuestionIndex),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (question.type == QuestionType.audioToText)
                      IconButton(
                        icon: const Icon(Icons.volume_up, size: 60, color: AppColors.primaryGreen),
                        onPressed: () {
                          // Play audio logic here
                        },
                      ),
                    Text(
                      question.questionText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            ...List.generate(question.options.length, (index) {
              return FadeInUp(
                delay: Duration(milliseconds: 100 * index),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton(
                    onPressed: () => notifier.answerQuestion(index),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryGreen,
                      side: BorderSide(color: AppColors.primaryGreen.withOpacity(0.2)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      question.options[index],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, QuizState state, QuizNotifier notifier) {
    final percentage = (state.score / quiz.questions.length * 100).toInt();
    
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                child: Icon(
                  percentage >= 70 ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                  size: 100,
                  color: AppColors.primaryGold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                percentage >= 70 ? "Congratulations!" : "Keep Practicing!",
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                "You scored $percentage%",
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                "Correct Answers: ${state.score} / ${quiz.questions.length}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 48),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        notifier.reset();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Retry"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Done"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

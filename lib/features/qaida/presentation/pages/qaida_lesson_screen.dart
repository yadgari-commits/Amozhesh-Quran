import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/services/qaida_data_service.dart';
import '../../domain/entities/qaida_lesson.dart';
import '../widgets/word_breakdown_viewer.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/progress_provider.dart';

class QaidaLessonScreen extends ConsumerStatefulWidget {
  final String title;
  
  const QaidaLessonScreen({super.key, required this.title});

  @override
  ConsumerState<QaidaLessonScreen> createState() => _QaidaLessonScreenState();
}

class _QaidaLessonScreenState extends ConsumerState<QaidaLessonScreen> {
  List<QaidaLesson> _lessons = [];
  bool _isLoading = true;
  int _currentLessonIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    final lessons = await QaidaDataService().getAllLessons();
    if (mounted) {
      setState(() {
        _lessons = lessons;
        _isLoading = false;
      });
    }
  }

  void _markAsCompleted() {
    final currentLesson = _lessons[_currentLessonIndex];
    ref.read(progressProvider.notifier).completeQaidaLesson(currentLesson.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lesson marked as completed!"), duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_lessons.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(child: Text("No lessons found.")),
      );
    }

    final currentLesson = _lessons[_currentLessonIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (_lessons.length > 1)
            PopupMenuButton<int>(
              onSelected: (index) {
                setState(() {
                  _currentLessonIndex = index;
                });
              },
              itemBuilder: (context) => List.generate(
                _lessons.length,
                (index) => PopupMenuItem(
                  value: index,
                  child: Text("Lesson ${index + 1}: ${_lessons[index].title}"),
                ),
              ),
              icon: const Icon(Icons.list),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lesson ${currentLesson.id}: ${currentLesson.title}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
            ),
            const SizedBox(height: 12),
            Text(
              currentLesson.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            
            // For now, keep the breakdown viewer as a highlighted example if it exists
            // Or just show it for the first word of the lesson
            if (currentLesson.examples.isNotEmpty)
              WordBreakdownViewer(
                fullWord: currentLesson.examples[0].word,
                fullWordAudio: currentLesson.examples[0].audio,
                units: [
                  WordUnit(text: currentLesson.examples[0].word[0], audioPath: "temp.mp3"),
                ],
              ),
            
            const SizedBox(height: 24),
            const Text(
              "Practice Examples",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemCount: currentLesson.examples.length,
              itemBuilder: (context, index) {
                return _buildExampleCard(currentLesson.examples[index].word);
              },
            ),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _markAsCompleted,
                child: const Text("Mark as Completed"),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (_currentLessonIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _currentLessonIndex--;
                        });
                      },
                      child: const Text("Previous"),
                    ),
                  ),
                if (_currentLessonIndex > 0 && _currentLessonIndex < _lessons.length - 1)
                  const SizedBox(width: 16),
                if (_currentLessonIndex < _lessons.length - 1)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentLessonIndex++;
                        });
                      },
                      child: const Text("Next Lesson"),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(String word) {
    return Card(
      elevation: 0,
      color: AppColors.primaryGreen.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.primaryGreen.withOpacity(0.1)),
      ),
      child: Center(
        child: Text(
          word,
          style: const TextStyle(
            fontSize: 28,
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
      ),
    );
  }
}

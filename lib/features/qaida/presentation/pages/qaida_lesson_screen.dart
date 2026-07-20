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
  int _selectedExampleIndex = 0;

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
      SnackBar(content: Text("completed".tr()), duration: const Duration(seconds: 1)),
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
    final selectedExample = currentLesson.examples.isNotEmpty 
        ? currentLesson.examples[_selectedExampleIndex < currentLesson.examples.length ? _selectedExampleIndex : 0]
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (_lessons.length > 1)
            PopupMenuButton<int>(
              onSelected: (index) {
                setState(() {
                  _currentLessonIndex = index;
                  _selectedExampleIndex = 0;
                });
              },
              itemBuilder: (context) => List.generate(
                _lessons.length,
                (index) => PopupMenuItem(
                  value: index,
                  child: Text("${"lesson".tr()} ${index + 1}: ${_lessons[index].title}"),
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
              "${"lesson".tr()} ${currentLesson.id}: ${currentLesson.title}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
            ),
            const SizedBox(height: 12),
            Text(
              currentLesson.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            
            if (selectedExample != null)
              WordBreakdownViewer(
                fullWord: selectedExample.word,
                fullWordAudio: selectedExample.audio,
                units: selectedExample.units.map((u) => WordUnit(text: u.text, audioPath: u.audio)).toList(),
              ),
            
            const SizedBox(height: 24),
            Text(
              "practice_examples".tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                return _buildExampleCard(index, currentLesson.examples[index].word);
              },
            ),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _markAsCompleted,
                child: Text("mark_completed".tr()),
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
                          _selectedExampleIndex = 0;
                        });
                      },
                      child: Text("previous".tr()),
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
                          _selectedExampleIndex = 0;
                        });
                      },
                      child: Text("next_lesson".tr()),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(int index, String word) {
    final isSelected = _selectedExampleIndex == index;
    return Card(
      elevation: isSelected ? 4 : 0,
      color: isSelected ? AppColors.primaryGold.withOpacity(0.1) : AppColors.primaryGreen.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primaryGold : AppColors.primaryGreen.withOpacity(0.1),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedExampleIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Text(
            word,
            style: TextStyle(
              fontSize: 28,
              fontFamily: 'Amiri',
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.primaryGold : AppColors.primaryGreen,
            ),
          ),
        ),
      ),
    );
  }
}
    );
  }
}

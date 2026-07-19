import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/progress_provider.dart';
import '../../mushaf/presentation/pages/surah_detail_screen.dart';

class DashboardScreen extends ConsumerWidget {
  final Function(int) onNavigate;
  const DashboardScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final percentage = (progress.overallProgress * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: Text("app_name".tr()),
        leading: const Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "welcome".tr(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Your progress is looking great. Keep going!"),
            const SizedBox(height: 24),
            
            // Continue Reading Section
            if (progress.lastReadSurah != null)
              _buildContinueReading(context, progress),
            
            const SizedBox(height: 16),

            // Progress Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryGreen, AppColors.secondaryGreen],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "daily_goal".tr(),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progress.overallProgress,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "$percentage% ${"completed".tr()}",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "start_learning".tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildLearningCard(
              context,
              title: "alphabet".tr(),
              subtitle: "Learn the foundation of Arabic",
              icon: Icons.sort_by_alpha,
              color: AppColors.primaryGreen.withOpacity(0.05),
              onTap: () => onNavigate(1),
            ),
            _buildLearningCard(
              context,
              title: "qaida".tr(),
              subtitle: "Step-by-step reading rules",
              icon: Icons.menu_book,
              color: AppColors.primaryGold.withOpacity(0.05),
              onTap: () => onNavigate(2),
            ),
            _buildLearningCard(
              context,
              title: "quran".tr(),
              subtitle: "Read and listen to Holy Quran",
              icon: Icons.auto_stories,
              color: AppColors.primaryGreen.withOpacity(0.05),
              onTap: () => onNavigate(3),
            ),
            _buildLearningCard(
              context,
              title: "quizzes".tr(),
              subtitle: "Test your knowledge",
              icon: Icons.quiz_outlined,
              color: Colors.blue.shade50,
              onTap: () => onNavigate(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueReading(BuildContext context, UserProgress progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bookmark, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "continue_reading".tr(),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  "${progress.lastReadSurahName} - ${"verses".tr()} ${progress.lastReadVerse}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurahDetailScreen(
                    surahNumber: progress.lastReadSurah!,
                    surahName: progress.lastReadSurahName ?? "Surah",
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text("resume".tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primaryGreen),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black26),
            ],
          ),
        ),
      ),
    );
  }
}

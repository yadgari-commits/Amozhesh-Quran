import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/progress_provider.dart';
import 'features/dashboard/presentation/pages/dashboard_screen.dart';
import 'features/alphabet/presentation/pages/alphabet_screen.dart';
import 'features/qaida/presentation/pages/qaida_lesson_screen.dart';
import 'features/mushaf/presentation/pages/surah_list_screen.dart';
import 'features/quiz/presentation/pages/quiz_list_screen.dart';
import 'features/profile/presentation/pages/profile_screen.dart';
import 'data/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file not found");
  }

  // Initialize Supabase (Optional)
  await SupabaseService().initialize();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'SA'),
        Locale('fa', 'AF'), // Persian (Dari)
        Locale('ps', 'AF'), // Pashto
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const ProviderScope(
        child: QuranApp(),
      ),
    ),
  );
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Quran Learning App',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const MainNavigation(),
        );
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _onNavigate(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      DashboardScreen(onNavigate: _onNavigate),
      const AlphabetScreen(),
      const QaidaLessonScreen(title: "Baghdadi Qaida"),
      const SurahListScreen(),
      const QuizListScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(icon: const Icon(Icons.dashboard_outlined), label: 'home'.tr()),
          NavigationDestination(icon: const Icon(Icons.sort_by_alpha), label: 'alphabet'.tr()),
          NavigationDestination(icon: const Icon(Icons.menu_book), label: 'qaida'.tr()),
          NavigationDestination(icon: const Icon(Icons.auto_stories), label: 'quran'.tr()),
          NavigationDestination(icon: const Icon(Icons.quiz_outlined), label: 'quizzes'.tr()),
          NavigationDestination(icon: const Icon(Icons.person_outline), label: 'profile'.tr()),
        ],
      ),
    );
  }
}


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
            Text("dashboard_subtitle".tr()),
            const SizedBox(height: 24),
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
              subtitle: "alphabet_subtitle".tr(),
              icon: Icons.sort_by_alpha,
              color: AppColors.primaryGreen.withOpacity(0.05),
              onTap: () => onNavigate(1),
            ),
            _buildLearningCard(
              context,
              title: "qaida".tr(),
              subtitle: "qaida_subtitle".tr(),
              icon: Icons.menu_book,
              color: AppColors.primaryGold.withOpacity(0.05),
              onTap: () => onNavigate(2),
            ),
            _buildLearningCard(
              context,
              title: "quran".tr(),
              subtitle: "quran_subtitle".tr(),
              icon: Icons.auto_stories,
              color: AppColors.primaryGreen.withOpacity(0.05),
              onTap: () => onNavigate(3),
            ),
            _buildLearningCard(
              context,
              title: "memorization".tr(),
              subtitle: "memorization_subtitle".tr(),
              icon: Icons.favorite_border,
              color: Colors.pink.shade50,
              onTap: () => onNavigate(4),
            ),
          ],
        ),
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
 ),
      ),
    );
  }
}
     ),
    );
  }
}

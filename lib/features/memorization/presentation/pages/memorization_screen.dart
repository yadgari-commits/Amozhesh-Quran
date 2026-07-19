import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../mushaf/domain/entities/surah.dart';
import 'hifz_session_screen.dart';

class MemorizationScreen extends StatelessWidget {
  const MemorizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memorization (Hifz)'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.primaryGreen.withOpacity(0.05),
            child: Row(
              children: [
                const Icon(Icons.psychology, size: 40, color: AppColors.primaryGreen),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hifz Assistant",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Select a Surah to start your memorization session.",
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: quranSurahs.length,
              itemBuilder: (context, index) {
                final surah = quranSurahs[index];
                return ListTile(
                  leading: Text(
                    surah.number.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                  ),
                  title: Text(surah.englishName),
                  subtitle: Text("${surah.versesCount} Verses"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HifzSessionScreen(surah: surah),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

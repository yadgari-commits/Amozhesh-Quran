import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/progress_provider.dart';
import '../../domain/entities/surah.dart';
import 'surah_detail_screen.dart';

class SurahListScreen extends ConsumerStatefulWidget {
  const SurahListScreen({super.key});

  @override
  ConsumerState<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends ConsumerState<SurahListScreen> {
  String _searchQuery = "";
  
  List<Surah> get _filteredSurahs {
    // Note: quranSurahs should be defined in surah.dart or a similar data file
    if (_searchQuery.isEmpty) return quranSurahs;
    return quranSurahs.where((surah) {
      return surah.englishName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             surah.name.contains(_searchQuery) ||
             surah.number.toString() == _searchQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('quran'.tr()),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "search_surah".tr(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchQuery = "";
                        });
                      },
                    )
                  : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _filteredSurahs.isEmpty 
        ? Center(child: Text("no_results".tr()))
        : ListView.separated(
        padding: const EdgeInsets.only(top: 8),
        itemCount: _filteredSurahs.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final surah = _filteredSurahs[index];
          final isCompleted = progress.completedSurahs.contains(surah.number);

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: isCompleted 
                  ? AppColors.primaryGreen.withOpacity(0.2)
                  : AppColors.primaryGreen.withOpacity(0.1),
              child: isCompleted 
                  ? const Icon(Icons.check, color: AppColors.primaryGreen)
                  : Text(
                      surah.number.toString(),
                      style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                    ),
            ),
            title: Text(
              surah.englishName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${surah.revelationType} • ${surah.versesCount} ${"verses".tr()}"),
            trailing: Text(
              surah.name,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Amiri',
                color: AppColors.primaryGreen,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurahDetailScreen(
                    surahNumber: surah.number,
                    surahName: surah.englishName,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
["الرَّحْمَٰنِ", "الرَّحِيمِ"]),
                      Verse(number: 3, text: "مَالِكِ يَوْمِ الدِّينِ", words: ["مَالِكِ", "يَوْمِ", "الدِّينِ"]),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

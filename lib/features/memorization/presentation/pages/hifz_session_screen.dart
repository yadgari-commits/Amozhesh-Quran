import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/services/quran_data_service.dart';
import '../../../../data/models/quran_verse_model.dart';
import '../../../mushaf/domain/entities/surah.dart';

class HifzSessionScreen extends StatefulWidget {
  final Surah surah;
  const HifzSessionScreen({super.key, required this.surah});

  @override
  State<HifzSessionScreen> createState() => _HifzSessionScreenState();
}

class _HifzSessionScreenState extends State<HifzSessionScreen> {
  List<QuranVerseModel> _verses = [];
  bool _isLoading = true;
  bool _hideAll = false;
  final Set<int> _revealedVerses = {};

  @override
  void initState() {
    super.initState();
    _loadVerses();
  }

  Future<void> _loadVerses() async {
    final verses = await QuranDataService().getVersesForSurah(widget.surah.number);
    if (mounted) {
      setState(() {
        _verses = verses;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hifz: ${widget.surah.englishName}"),
        actions: [
          IconButton(
            icon: Icon(_hideAll ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _hideAll = !_hideAll;
                _revealedVerses.clear();
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Tap on a hidden verse to reveal it temporarily.",
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade600),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _verses.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final verse = _verses[index];
                      final isHidden = _hideAll && !_revealedVerses.contains(index);

                      return GestureDetector(
                        onTap: () {
                          if (_hideAll) {
                            setState(() {
                              if (_revealedVerses.contains(index)) {
                                _revealedVerses.remove(index);
                              } else {
                                _revealedVerses.add(index);
                              }
                            });
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isHidden 
                                ? Colors.grey.shade200 
                                : AppColors.primaryGreen.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                isHidden ? "•••• •••• •••• ••••" : verse.text,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Amiri',
                                  color: isHidden ? Colors.grey.shade400 : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: AppColors.primaryGold,
                                    child: Text(
                                      verse.verse.toString(),
                                      style: const TextStyle(fontSize: 10, color: Colors.white),
                                    ),
                                  ),
                                  if (isHidden)
                                    const Icon(Icons.touch_app, size: 16, color: Colors.grey)
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

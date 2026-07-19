import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/services/quran_data_service.dart';
import '../../../../data/models/quran_verse_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/progress_provider.dart';

class SurahDetailScreen extends ConsumerStatefulWidget {
  final int surahNumber;
  final String surahName;

  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  @override
  ConsumerState<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends ConsumerState<SurahDetailScreen> {
  int? _activeVerseIndex;
  List<QuranVerseModel> _verses = [];
  bool _isLoading = true;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadVerses();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(progressProvider.notifier);
      notifier.completeSurah(widget.surahNumber);
      notifier.saveLastRead(widget.surahNumber, widget.surahName, 1);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadVerses() async {
    final verses = await QuranDataService().getVersesForSurah(widget.surahNumber);
    if (mounted) {
      setState(() {
        _verses = verses;
        _isLoading = false;
      });
    }
  }

  Future<void> _playVerseAudio(int verseIndex) async {
    final verse = _verses[verseIndex];
    // Construct the path for downloaded offline audio
    final audioPath = 'assets/audio/quran/${widget.surahNumber}/${verse.verse}.mp3';
    
    try {
      setState(() {
        _activeVerseIndex = verseIndex;
      });

      // Update progress
      ref.read(progressProvider.notifier).saveLastRead(
        widget.surahNumber, 
        widget.surahName, 
        verse.verse
      );

      await _audioPlayer.setAsset(audioPath);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint("Audio play error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("صوت این آیه هنوز دانلود نشده است."),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _activeVerseIndex = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.surahName),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
        children: [
          if (widget.surahNumber != 1 && widget.surahNumber != 9)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
                style: TextStyle(fontSize: 32, fontFamily: 'Amiri', color: AppColors.primaryGreen),
              ),
            ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _verses.length,
              separatorBuilder: (context, index) => const Divider(height: 30),
              itemBuilder: (context, vIndex) {
                final verse = _verses[vIndex];
                final isVerseActive = _activeVerseIndex == vIndex;
                
                return GestureDetector(
                  onTap: () => _playVerseAudio(vIndex),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isVerseActive ? AppColors.primaryGreen.withOpacity(0.08) : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isVerseActive ? AppColors.primaryGreen.withOpacity(0.2) : Colors.transparent,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          verse.text,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: 'Amiri',
                            color: isVerseActive ? AppColors.primaryGreen : Colors.black87,
                            height: 2.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGold,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "آیه ${verse.verse}",
                                style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (isVerseActive)
                              const Icon(Icons.volume_up, color: AppColors.primaryGreen, size: 24),
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
t.end,
                            children: [
                              TextButton.icon(
                                onPressed: () => _openAiTeacher(verse.text),
                                icon: const Icon(Icons.mic, size: 16, color: AppColors.primaryGreen),
                                label: const Text("Practice with AI", style: TextStyle(fontSize: 12, color: AppColors.primaryGreen)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
                        ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';

class WordUnit {
  final String text;
  final String audioPath;

  const WordUnit({required this.text, required this.audioPath});
}

class WordBreakdownViewer extends StatefulWidget {
  final String fullWord;
  final List<WordUnit> units;
  final String fullWordAudio;

  const WordBreakdownViewer({
    super.key,
    required this.fullWord,
    required this.units,
    required this.fullWordAudio,
  });

  @override
  State<WordBreakdownViewer> createState() => _WordBreakdownViewerState();
}

class _WordBreakdownViewerState extends State<WordBreakdownViewer> {
  int? _activeUnitIndex;
  bool _isPlayingFullWord = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playUnit(int index) async {
    final unit = widget.units[index];
    setState(() {
      _activeUnitIndex = index;
      _isPlayingFullWord = false;
    });
    
    try {
      await _audioPlayer.setAsset('assets/audio/qaida/${unit.audioPath}');
      await _audioPlayer.play();
    } catch (e) {
      debugPrint("Audio play error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _activeUnitIndex = null;
        });
      }
    }
  }

  Future<void> _playFullWord() async {
    setState(() {
      _isPlayingFullWord = true;
      _activeUnitIndex = null;
    });
    
    try {
      await _audioPlayer.setAsset('assets/audio/qaida/${widget.fullWordAudio}');
      await _audioPlayer.play();
    } catch (e) {
      debugPrint("Audio play error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isPlayingFullWord = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Full Word Display
            GestureDetector(
              onTap: _playFullWord,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  color: _isPlayingFullWord ? AppColors.primaryGold.withOpacity(0.15) : AppColors.primaryGreen.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: _isPlayingFullWord ? AppColors.primaryGold : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Text(
                  widget.fullWord,
                  style: TextStyle(
                    fontSize: 54,
                    color: _isPlayingFullWord ? AppColors.primaryGold : AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Amiri',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Units Breakdown
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: List.generate(widget.units.length, (index) {
                final unit = widget.units[index];
                final isActive = _activeUnitIndex == index;
                
                return GestureDetector(
                  onTap: () => _playUnit(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primaryGold : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                        ),
                      ],
                      border: Border.all(
                        color: isActive ? AppColors.primaryGold : AppColors.primaryGreen.withOpacity(0.1),
                      ),
                    ),
                    child: Text(
                      unit.text,
                      style: TextStyle(
                        fontSize: 36,
                        color: isActive ? Colors.white : AppColors.primaryGreen,
                        fontFamily: 'Amiri',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "audio_instruction".tr(),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

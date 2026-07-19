import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/arabic_letter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/progress_provider.dart';

class LetterCard extends ConsumerStatefulWidget {
  final ArabicLetter letter;
  final int index;
  
  const LetterCard({super.key, required this.letter, required this.index});

  @override
  ConsumerState<LetterCard> createState() => _LetterCardState();
}

class _LetterCardState extends ConsumerState<LetterCard> {
  late AudioPlayer _player;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
    });

    try {
      await _player.setAsset('assets/audio/${widget.letter.audioPath}');
      await _player.play();
      
      // Mark as completed
      ref.read(progressProvider.notifier).completeLetter(widget.index);
    } catch (e) {
      debugPrint("Error playing audio: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final isCompleted = progress.completedAlphabet.contains(widget.index);

    return GestureDetector(
      onTap: _playSound,
      child: ZoomIn(
        child: Container(
          decoration: BoxDecoration(
            color: _isPlaying ? AppColors.primaryGold : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: _isPlaying 
                  ? AppColors.primaryGold 
                  : (isCompleted ? AppColors.primaryGreen : AppColors.primaryGreen.withOpacity(0.1)),
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              if (isCompleted)
                const Positioned(
                  top: 8,
                  left: 8,
                  child: Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 16),
                ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.letter.char,
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: _isPlaying ? Colors.white : AppColors.primaryGreen,
                        fontFamily: 'Amiri',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.letter.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: _isPlaying ? Colors.white : AppColors.accentBrown,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/services/supabase_service.dart';

class UserProgress {
  final Set<int> completedAlphabet;
  final Set<int> completedQaidaLessons;
  final Set<int> completedSurahs;
  final int? lastReadSurah;
  final String? lastReadSurahName;
  final int? lastReadVerse;

  UserProgress({
    this.completedAlphabet = const {},
    this.completedQaidaLessons = const {},
    this.completedSurahs = const {},
    this.lastReadSurah,
    this.lastReadSurahName,
    this.lastReadVerse,
  });

  UserProgress copyWith({
    Set<int>? completedAlphabet,
    Set<int>? completedQaidaLessons,
    Set<int>? completedSurahs,
    int? lastReadSurah,
    String? lastReadSurahName,
    int? lastReadVerse,
  }) {
    return UserProgress(
      completedAlphabet: completedAlphabet ?? this.completedAlphabet,
      completedQaidaLessons: completedQaidaLessons ?? this.completedQaidaLessons,
      completedSurahs: completedSurahs ?? this.completedSurahs,
      lastReadSurah: lastReadSurah ?? this.lastReadSurah,
      lastReadSurahName: lastReadSurahName ?? this.lastReadSurahName,
      lastReadVerse: lastReadVerse ?? this.lastReadVerse,
    );
  }

  double get overallProgress {
    int totalItems = 28 + 8 + 114; 
    int completedItems = completedAlphabet.length + completedQaidaLessons.length + completedSurahs.length;
    return totalItems > 0 ? completedItems / totalItems : 0.0;
  }
}

class ProgressNotifier extends StateNotifier<UserProgress> {
  ProgressNotifier() : super(UserProgress()) {
    _init();
  }

  late Box _box;
  final _supabase = SupabaseService().client;

  Future<void> _init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('user_progress');
    
    final alphabet = _box.get('alphabet', defaultValue: <int>[]);
    final qaida = _box.get('qaida', defaultValue: <int>[]);
    final surahs = _box.get('surahs', defaultValue: <int>[]);
    final lastSurah = _box.get('last_surah');
    final lastSurahName = _box.get('last_surah_name');
    final lastVerse = _box.get('last_verse');

    state = UserProgress(
      completedAlphabet: Set<int>.from(alphabet),
      completedQaidaLessons: Set<int>.from(qaida),
      completedSurahs: Set<int>.from(surahs),
      lastReadSurah: lastSurah,
      lastReadSurahName: lastSurahName,
      lastReadVerse: lastVerse,
    );

    _syncFromCloud();
  }

  Future<void> _syncFromCloud() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final response = await _supabase
          .from('user_progress')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (response != null) {
        final cloudAlphabet = Set<int>.from(response['alphabet'] ?? []);
        final cloudQaida = Set<int>.from(response['qaida'] ?? []);
        final cloudSurahs = Set<int>.from(response['surahs'] ?? []);
        
        final mergedAlphabet = {...state.completedAlphabet, ...cloudAlphabet};
        final mergedQaida = {...state.completedQaidaLessons, ...cloudQaida};
        final mergedSurahs = {...state.completedSurahs, ...cloudSurahs};

        state = state.copyWith(
          completedAlphabet: mergedAlphabet,
          completedQaidaLessons: mergedQaida,
          completedSurahs: mergedSurahs,
        );

        _box.put('alphabet', mergedAlphabet.toList());
        _box.put('qaida', mergedQaida.toList());
        _box.put('surahs', mergedSurahs.toList());
      }
    } catch (e) {
      print('Cloud sync error: $e');
    }
  }

  Future<void> _saveToCloud() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('user_progress').upsert({
        'user_id': user.id,
        'alphabet': state.completedAlphabet.toList(),
        'qaida': state.completedQaidaLessons.toList(),
        'surahs': state.completedSurahs.toList(),
        'last_surah': state.lastReadSurah,
        'last_verse': state.lastReadVerse,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Cloud save error: $e');
    }
  }

  void saveLastRead(int surahNumber, String surahName, int verseNumber) {
    state = state.copyWith(
      lastReadSurah: surahNumber,
      lastReadSurahName: surahName,
      lastReadVerse: verseNumber,
    );
    _box.put('last_surah', surahNumber);
    _box.put('last_surah_name', surahName);
    _box.put('last_verse', verseNumber);
    _saveToCloud();
  }

  void completeLetter(int index) {
    final newSet = {...state.completedAlphabet, index};
    state = state.copyWith(completedAlphabet: newSet);
    _box.put('alphabet', newSet.toList());
    _saveToCloud();
  }

  void completeQaidaLesson(int id) {
    final newSet = {...state.completedQaidaLessons, id};
    state = state.copyWith(completedQaidaLessons: newSet);
    _box.put('qaida', newSet.toList());
    _saveToCloud();
  }

  void completeSurah(int number) {
    final newSet = {...state.completedSurahs, number};
    state = state.copyWith(completedSurahs: newSet);
    _box.put('surahs', newSet.toList());
    _saveToCloud();
  }
}

final progressProvider = StateNotifierProvider<ProgressNotifier, UserProgress>((ref) {
  return ProgressNotifier();
});
essProvider = StateNotifierProvider<ProgressNotifier, UserProgress>((ref) {
  return ProgressNotifier();
});
essNotifier();
});

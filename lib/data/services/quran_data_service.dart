import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quran_verse_model.dart';

class QuranDataService {
  static final QuranDataService _instance = QuranDataService._internal();
  factory QuranDataService() => _instance;
  QuranDataService._internal();

  Map<int, List<QuranVerseModel>> _cache = {};

  Future<List<QuranVerseModel>> getVersesForSurah(int surahNumber, {String lang = 'ar'}) async {
    if (_cache.containsKey(surahNumber)) {
      return _cache[surahNumber]!;
    }

    try {
      final String response = await rootBundle.loadString('assets/data/quran/$lang.json');
      final data = json.decode(response);
      final List<dynamic> versesJson = data['quran'];
      
      final verses = versesJson
          .where((v) => v['chapter'] == surahNumber)
          .map((v) => QuranVerseModel.fromJson(v))
          .toList();
          
      _cache[surahNumber] = verses;
      return verses;
    } catch (e) {
      print("Error loading Quran data: $e");
      return [];
    }
  }
}

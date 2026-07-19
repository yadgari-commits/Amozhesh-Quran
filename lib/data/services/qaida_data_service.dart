import 'dart:convert';
import 'package:flutter/services.dart';
import '../../features/qaida/domain/entities/qaida_lesson.dart';

class QaidaDataService {
  static final QaidaDataService _instance = QaidaDataService._internal();
  factory QaidaDataService() => _instance;
  QaidaDataService._internal();

  Future<List<QaidaLesson>> getAllLessons() async {
    try {
      final String response = await rootBundle.loadString('assets/data/qaida_lessons.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => QaidaLesson.fromJson(json)).toList();
    } catch (e) {
      print("Error loading Qaida lessons: $e");
      return [];
    }
  }
}

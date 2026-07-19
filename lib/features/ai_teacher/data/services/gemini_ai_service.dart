import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiAiService {
  late final GenerativeModel _model;
  
  GeminiAiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  /// Evaluates user recitation from an audio file.
  /// [audioPath] Path to the recorded audio file.
  /// [expectedText] The Quranic verse text the user was supposed to recite.
  Future<String> evaluateRecitation(String audioPath, String expectedText) async {
    try {
      final audioBytes = await File(audioPath).readAsBytes();
      
      final prompt = [
        Content.multi([
          TextPart("""
            You are an expert Quran teacher. 
            Listen to this recitation and compare it with the following Quranic text: "$expectedText".
            Identify any pronunciation or Tajweed mistakes.
            Provide feedback in a structured format:
            1. Correct words
            2. Mispronounced words
            3. Tajweed suggestions
            4. Encouragement score (1-100)
            
            Keep the feedback encouraging and helpful for a beginner.
            Respond in the user's preferred language.
          """),
          DataPart('audio/mp3', audioBytes),
        ])
      ];

      final response = await _model.generateContent(prompt);
      return response.text ?? "Unable to analyze recitation.";
    } catch (e) {
      return "AI Teacher Error: $e";
    }
  }
}

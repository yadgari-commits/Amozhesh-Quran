import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/services/gemini_ai_service.dart';

class AiTeacherScreen extends StatefulWidget {
  final String verseText;
  
  const AiTeacherScreen({super.key, required this.verseText});

  @override
  State<AiTeacherScreen> createState() => _AiTeacherScreenState();
}

class _AiTeacherScreenState extends State<AiTeacherScreen> {
  bool _isRecording = false;
  bool _isAnalyzing = false;
  String _feedback = "";
  final GeminiAiService _aiService = GeminiAiService();
  final AudioRecorder _audioRecorder = AudioRecorder();

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  void _toggleRecording() async {
    if (_isRecording) {
      // Stop and evaluate
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _isAnalyzing = true;
        _feedback = "AI is analyzing your recitation...";
      });
      
      if (path != null) {
        final result = await _aiService.evaluateRecitation(path, widget.verseText);
        setState(() {
          _feedback = result;
          _isAnalyzing = false;
        });
      }
    } else {
      final bool hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) return;

      final Directory tempDir = await getTemporaryDirectory();
      final String path = '${tempDir.path}/recitation.m4a';
      
      const config = RecordConfig();

      await _audioRecorder.start(config, path: path);

      setState(() {
        _isRecording = true;
        _feedback = "Listening...";
      });
    }
  }

  Widget _buildFeedbackContent() {
    if (_isAnalyzing) {
      return const Column(
        children: [
          CircularProgressIndicator(color: AppColors.primaryGreen),
          SizedBox(height: 12),
          Text("Analyzing with Gemini AI...", style: TextStyle(fontStyle: FontStyle.italic)),
        ],
      );
    }
    
    bool isPositive = !_feedback.toLowerCase().contains("wrong") && 
                    !_feedback.toLowerCase().contains("try again") &&
                    !_feedback.toLowerCase().contains("error");

    return Column(
      children: [
        Icon(
          isPositive ? Icons.check_circle : Icons.info_outline,
          color: isPositive ? Colors.green : AppColors.primaryGold,
          size: 48,
        ),
        const SizedBox(height: 12),
        Text(
          _feedback,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: AppColors.accentBrown, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Quran Teacher'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          image: DecorationImage(
            image: const AssetImage('assets/images/pattern.png'),
            opacity: 0.03,
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              FadeInDown(
                child: const Text(
                  "Recite this verse clearly:",
                  style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w300),
                ),
              ),
              const SizedBox(height: 20),
              FadeIn(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                    child: Text(
                      widget.verseText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32, 
                        fontFamily: 'Amiri', 
                        color: AppColors.primaryGreen,
                        height: 1.8,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              if (_feedback.isNotEmpty || _isAnalyzing)
                FadeInUp(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: AppColors.primaryGreen.withOpacity(0.1)),
                    ),
                    child: _buildFeedbackContent(),
                  ),
                ),
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    if (_isRecording)
                      Pulse(
                        infinite: true,
                        child: Container(
                          margin: const EdgeInsets.bottom(20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (index) => 
                              Container(
                                width: 4,
                                height: 20 + (index % 2 == 0 ? 10 : 0),
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    GestureDetector(
                      onTap: _isAnalyzing ? null : _toggleRecording,
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: _isRecording ? Colors.red : AppColors.primaryGreen,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (_isRecording ? Colors.red : AppColors.primaryGreen).withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isRecording ? Icons.stop : Icons.mic,
                          color: Colors.white,
                          size: 45,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isRecording ? "Listening... Tap to Stop" : "Tap to Start Recitation",
                      style: TextStyle(
                        color: _isRecording ? Colors.red : AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

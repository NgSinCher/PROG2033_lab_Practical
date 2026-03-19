import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';

class AiService {
  
  static Future<Uint8List?> generatePoster(
    String theme,
    String location,
    double budget,
  ) async {
    
    const String apiUrl = 'https://router.huggingface.co/hf-inference/models/stabilityai/stable-diffusion-xl-base-1.0';
    const String hfToken = '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'; 

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $hfToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "inputs": "University student event poster for $theme, high resolution design",
          "options": {"wait_for_model": true}
        }),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) return response.bodyBytes;
      throw Exception("HF failed");
    } catch (e) {
      print("AI Poster failed, switching to high-quality backup...");
      
      
      String backupUrl = "https://images.unsplash.com/photo-1540317580384-e5d43867abc6?q=80&w=800&auto=format&fit=crop";
      if (theme.contains('Career')) backupUrl = "https://images.unsplash.com/photo-1521737711867-e3b97375f902?q=80&w=800&auto=format&fit=crop";
      
      try {
        final res = await http.get(Uri.parse(backupUrl));
        return res.bodyBytes;
      } catch (_) {
        return null;
      }
    }
  }

  
  static Future<Map<String, dynamic>> generatePlanning(
    String theme,
    double duration,
    double budget,
    int participants,
    String location,
  ) async {
    try {
      // 如果 Firebase 没初始化成功，直接抛错进 catch 用保底数据
      if (Firebase.apps.isEmpty) throw Exception("Firebase Not Ready");

      final model = FirebaseVertexAI.instance.generativeModel(
        model: 'gemini-1.5-flash', 
        generationConfig: GenerationConfig(responseMimeType: 'application/json'),
      );

      final prompt = "JSON for event: $theme. Structure: {'activities': [], 'logistics': '', 'catering': ''}";
      final response = await model.generateContent([Content.text(prompt)]);
      
      final jsonString = response.text!.replaceAll('```json', '').replaceAll('```', '').trim();
      return jsonDecode(jsonString);
    } catch (e) {
      print("Using Hardcoded Plan Data because: $e");
      
      return {
        "activities": [
          "Registration at $location",
          "Main Event: $theme",
          "Q&A and Workshop",
          "Closing Ceremony"
        ],
        "logistics": "Venue: $location. Staff: 5 people.",
        "catering": "Budget: RM $budget for snacks and drinks.",
      };
    }
  }
}

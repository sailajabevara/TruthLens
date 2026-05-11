import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ChatService {
  // Use 10.0.2.2 for Android emulator to access localhost
  static String get _baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return "http://10.0.2.2:5000/chat";
    }
    return "http://localhost:5000/chat";
  }

  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "message": message,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["reply"] ?? "No reply from backend.";
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Connection error: $e");
    }
  }
}

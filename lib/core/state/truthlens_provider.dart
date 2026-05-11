// lib/providers/truthlens_provider.dart

import 'package:flutter/material.dart';
import 'package:truthlens/features/threat_intelligence/domain/entities/scam_report.dart';
import 'package:truthlens/core/network/claude_api_service.dart';
import 'package:truthlens/features/chat/data/datasources/chat_service.dart';
import 'package:truthlens/core/intelligence/engine/fraud_intelligence_engine.dart';

enum AppLanguage { english, telugu }

class TrustShieldProvider extends ChangeNotifier {
  final FraudIntelligenceEngine _engine = FraudIntelligenceEngine();
  final ClaudeApiService _claudeService = ClaudeApiService();

  final List<ScanRecord> _history = <ScanRecord>[];
  ScanRecord? _lastResult;
  bool _isBusy = false;
  ThemeMode _themeMode = ThemeMode.dark;
  AppLanguage _language = AppLanguage.english;

  // Track conversation history for AI Chat screen
  final List<Map<String, String>> _chatHistory = [];

  List<ScanRecord> get history => List.unmodifiable(_history);
  ScanRecord? get lastResult => _lastResult;
  bool get isBusy => _isBusy;
  ThemeMode get themeMode => _themeMode;
  AppLanguage get language => _language;
  List<Map<String, String>> get chatHistory => List.unmodifiable(_chatHistory);

  int get personalRiskScore {
    if (_history.isEmpty) return 0;
    final suspicious = _history.where((e) => e.isLikelyScam).length;
    return ((suspicious / _history.length) * 100).round();
  }

  /// Main analysis entry point.
  /// Always uses the AI service for all content types (URL, Message, News, Document, Images).
  Future<ScanRecord> analyzeInput({
    required ScanType scanType,
    required String content,
  }) async {
    _isBusy = true;
    notifyListeners();

    try {
      final record = await _analyzeWithAI(content, scanType);
      
      _history.insert(0, record);
      _lastResult = record;
      return record;
    } catch (e) {
      // Fallback to local intelligence engine ONLY if AI fails completely (e.g., no internet)
      final record = await _analyzeLocally(content, scanType);
      _history.insert(0, record);
      _lastResult = record;
      return record;
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  /// AI-powered analysis for all scan types
  Future<ScanRecord> _analyzeWithAI(
    String content,
    ScanType scanType,
  ) async {
    final result = await _claudeService.analyzeContent(
      content: content,
      scanType: scanType,
      language: _language == AppLanguage.telugu ? 'telugu' : 'english',
    );

    return ScanRecord(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      scanType: scanType,
      input: content,
      trustScore: result.trustScore,
      riskLevel: result.riskLevel,
      isLikelyScam: result.isLikelyScam,
      explanation: result.toExplanationList(),
      scannedAt: DateTime.now(),
    );
  }

  /// Local enterprise rule-based analysis (FraudIntelligenceEngine) as a fallback
  Future<ScanRecord> _analyzeLocally(
    String content,
    ScanType scanType,
  ) async {
    final report = await _engine.analyze(content, scanType);
    return ScanRecord(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      scanType: scanType,
      input: content,
      trustScore: report.finalTrustScore,
      riskLevel: report.riskLevel,
      isLikelyScam: report.isLikelyScam,
      explanation: report.explanation,
      scannedAt: DateTime.now(),
    );
  }

  /// Send a chat message — uses AI API for smarter replies
  Future<String> sendChatMessage(String userMessage) async {
    _chatHistory.add({'role': 'user', 'content': userMessage});
    notifyListeners();

    Object? firstError;
    try {
      // 1. Try direct OpenRouter call (highest quality, supports history)
      final reply = await _claudeService.chatAnalyze(
        userMessage: userMessage,
        conversationHistory: _chatHistory.length > 1
            ? _chatHistory.sublist(0, _chatHistory.length - 1)
            : [],
        language: _language == AppLanguage.telugu ? 'telugu' : 'english',
      );
      _chatHistory.add({'role': 'assistant', 'content': reply});
      notifyListeners();
      return reply;
    } catch (e) {
      firstError = e;
      debugPrint('Direct AI call failed: $e. Trying backend fallback...');
    }

    try {
      // 2. Try backend fallback (if configured)
      final reply = await ChatService.sendMessage(userMessage);
      _chatHistory.add({'role': 'assistant', 'content': reply});
      notifyListeners();
      return reply;
    } catch (backendError) {
      debugPrint('Backend call failed: $backendError.');
      // If both fail, throw the more descriptive error (usually the first one)
      throw firstError;
    }
  }

  void clearChatHistory() {
    _chatHistory.clear();
    notifyListeners();
  }

  void addAssistantChatMessage(String assistantText) {
    _chatHistory.add({'role': 'assistant', 'content': assistantText});
    notifyListeners();
  }

  void addUserChatMessage(String userText) {
    _chatHistory.add({'role': 'user', 'content': userText});
    notifyListeners();
  }

  void updateThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void updateLanguage(AppLanguage language) {
    if (_language == language) return;
    _language = language;
    notifyListeners();
  }
}
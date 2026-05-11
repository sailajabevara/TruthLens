// lib/services/claude_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:truthlens/features/threat_intelligence/domain/entities/scam_report.dart';

/// Response returned from Claude API analysis
class ClaudeAnalysisResult {
  ClaudeAnalysisResult({
    required this.trustScore,
    required this.riskLevel,
    required this.isLikelyScam,
    required this.verdict,
    required this.explanation,
    required this.redFlags,
    required this.legitimacySignals,
    required this.recommendation,
  });

  final int trustScore;
  final RiskLevel riskLevel;
  final bool isLikelyScam;
  final String verdict; // "REAL", "FAKE", or "SUSPICIOUS"
  final String explanation;
  final List<String> redFlags;
  final List<String> legitimacySignals;
  final String recommendation;

  /// Convert to ScanRecord explanation list (used by existing ResultScreen)
  List<String> toExplanationList() {
    final lines = <String>[];
    lines.add('Verdict: $verdict');
    lines.add(explanation);
    if (redFlags.isNotEmpty) {
      lines.add('--- Red Flags ---');
      lines.addAll(redFlags.map((f) => '🚩 $f'));
    }
    if (legitimacySignals.isNotEmpty) {
      lines.add('--- Legitimacy Signals ---');
      lines.addAll(legitimacySignals.map((s) => '✅ $s'));
    }
    lines.add('--- Recommendation ---');
    lines.add(recommendation);
    return lines;
  }
}

class ClaudeApiService {
  // ──────────────────────────────────────────────
  // CONFIGURATION
  // ──────────────────────────────────────────────
  static String get _openRouterApiKey {
   const fromEnv = String.fromEnvironment('OPENROUTER_API_KEY');

if (fromEnv.isEmpty) {
  throw ClaudeApiException(
    'Missing OPENROUTER_API_KEY. '
    'Run with --dart-define=OPENROUTER_API_KEY=your_key.',
  );
}

return fromEnv; }

  static const String _openRouterUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static String get _model {
    const fromEnv = String.fromEnvironment('OPENROUTER_MODEL');
    if (fromEnv.isNotEmpty) return fromEnv;
    return 'google/gemini-2.0-flash-001';
  }
  static const int _maxTokens = 800;

  /// Analyzes content using OpenRouter AI based on the scan type.
  Future<ClaudeAnalysisResult> analyzeContent({
    required String content,
    required ScanType scanType,
    String language = 'english',
  }) async {
    _ensureApiKeyConfigured();
    final prompt = _buildAnalysisPrompt(content, scanType, language);
    final systemPrompt = _buildSystemPrompt(scanType);

    try {
      final response = await http
          .post(
            Uri.parse(_openRouterUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_openRouterApiKey',
              'X-Title': 'TruthLens AI',
            },
            body: jsonEncode({
              'model': _model,
              'max_tokens': _maxTokens,
              'messages': [
                {'role': 'system', 'content': systemPrompt},
                {'role': 'user', 'content': prompt},
              ],
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final choices = body['choices'] as List<dynamic>?;
        if (choices == null || choices.isEmpty) {
          throw ClaudeApiException('AI did not return a valid response.');
        }
        final rawText = (choices.first['message']['content'] as String? ?? '').trim();
        return _parseClaudeResponse(rawText);
      } else if (response.statusCode == 401) {
        throw ClaudeApiException('Invalid OpenRouter API key.');
      } else {
        throw ClaudeApiException(
          'OpenRouter API error ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      throw ClaudeApiException('Network error: $e');
    }
  }

  /// Chat message analysis — used by AiChatAssistantScreen
  Future<String> chatAnalyze({
    required String userMessage,
    required List<Map<String, String>> conversationHistory,
    String language = 'english',
  }) async {
    if (_openRouterApiKey.trim().isEmpty) {
      throw ClaudeApiException('API Key is missing. Please run with --dart-define=OPENROUTER_API_KEY=...');
    }

    // Limit history to last 10 messages to keep context window clean
    final limitedHistory = conversationHistory.length > 10 
        ? conversationHistory.sublist(conversationHistory.length - 10)
        : conversationHistory;

    final messages = [
      {'role': 'system', 'content': _chatSystemPrompt(language)},
      ...limitedHistory.map(
        (m) => {'role': m['role']!, 'content': m['content']!},
      ),
      {'role': 'user', 'content': userMessage},
    ];

    try {
      final response = await http
          .post(
            Uri.parse(_openRouterUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_openRouterApiKey',
              // Use standard headers that are less likely to trigger CORS issues or browser blocks
              'X-Title': 'TruthLens AI',
            },
            body: jsonEncode({
              'model': _model,
              'max_tokens': 500,
              'messages': messages,
              'temperature': 0.7,
            }),
          )
          .timeout(const Duration(seconds: 25));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final choices = body['choices'] as List<dynamic>?;
        if (choices == null || choices.isEmpty) {
          throw ClaudeApiException('Empty response from AI service.');
        }
        final reply = (choices.first['message']['content'] as String? ?? '').trim();
        if (reply.isEmpty) {
          return 'I\'m sorry, I couldn\'t generate a response. Could you try rephrasing?';
        }
        return reply;
      } else if (response.statusCode == 401) {
        throw ClaudeApiException('Invalid API Key (Unauthorized).');
      } else if (response.statusCode == 429) {
        throw ClaudeApiException('Rate limit reached. Please try again in a moment.');
      } else {
        throw ClaudeApiException('Server error (${response.statusCode}): ${response.reasonPhrase}');
      }
    } catch (e) {
      if (e is ClaudeApiException) rethrow;
      throw ClaudeApiException('Connection failed: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────
  // PROMPTS
  // ─────────────────────────────────────────────────────────────

  String _buildSystemPrompt(ScanType scanType) {
    final basePrompt = '''
You are TruthLens AI, a specialized fraud detection assistant for Indian users.
Your job is to analyze the provided content to determine if it is 
REAL (legitimate/safe) or FAKE (scam/fraud/phishing).

You MUST respond ONLY in valid JSON — no markdown fences, no preamble, no explanation outside JSON.

JSON schema (all fields required):
{
  "verdict": "REAL" | "FAKE" | "SUSPICIOUS",
  "trust_score": <integer 0-100>,
  "explanation": "<2-3 sentence summary of your reasoning>",
  "red_flags": ["<flag1>", "<flag2>", ...],
  "legitimacy_signals": ["<signal1>", "<signal2>", ...],
  "recommendation": "<one clear action for the user to take>"
}

Scoring guide:
- trust_score 75-100 → REAL/SAFE
- trust_score 40-74  → SUSPICIOUS
- trust_score 0-39   → FAKE/SCAM
''';

    final specificRules = switch (scanType) {
      ScanType.document => '''
Focus on: Internship/Job offers, official letters, or policies.
Red flags: Upfront fees, unrealistic salary, WhatsApp contact, free email domains (.xyz, gmail), grammar errors, urgency, missing MCA registration.
Legitimacy signals: Official domain email, LinkedIn presence, clear role description, verifiable company address.
''',
      ScanType.url => '''
Focus on: Identifying phishing, malware, or scam websites.
Red flags: Misspelled brand names (e.g., faceb0ok), obscure TLDs (.xyz, .top), IP addresses instead of domains, HTTP instead of HTTPS, URL shorteners masking the destination.
Legitimacy signals: Official brand domain, secure connection, verifiable WHOIS data.
''',
      ScanType.news => '''
Focus on: Detecting fake news, misinformation, or clickbait.
Red flags: Emotionally charged language, lack of credible sources, known fake news patterns, extreme urgency or "shocking" claims.
Legitimacy signals: Verifiable facts, neutral tone, links to reputable news outlets.
''',
      ScanType.message => '''
Focus on: SMS, WhatsApp, or email phishing scams.
Red flags: Requests for OTP/password, urgent payment requests (UPI/GPay), unknown sender, threatening language (e.g., "your account will be blocked"), suspicious links.
Legitimacy signals: Known verified sender, no pressure to click links or share data.
''',
    };

    return '$basePrompt\n$specificRules';
  }

  String _buildAnalysisPrompt(String content, ScanType scanType, String language) {
    final langNote = language == 'telugu'
        ? 'The user speaks Telugu. Keep the "explanation" and "recommendation" fields in simple English but mark them as Telugu-friendly.'
        : '';
    return '''
Analyze this ${scanType.label} for legitimacy or scam indicators. $langNote

--- CONTENT START ---
$content
--- CONTENT END ---

Respond ONLY with the JSON object. No other text.
''';
  }

  String _chatSystemPrompt(String language) {
    final teluguNote = language == 'telugu'
        ? 'The user prefers Telugu. Reply in simple Telugu mixed with English technical terms.'
        : 'Reply in clear English.';
    return '''
You are TruthLens AI, a brilliant, witty, and multifaceted AI assistant. $teluguNote

Think of yourself as a combination of a wise mentor, a tech-savvy best friend, and a sharp fraud investigator. Your personality should be:
1. **Versatile**: You can talk about anything—science, history, philosophy, or just small talk. Be as helpful and broad as ChatGPT.
2. **Engaging & Witty**: Don't be afraid to use a bit of humor, emojis, or a lighthearted tone when appropriate. If the user asks for a joke or something funny, deliver!
3. **Eagle-Eyed**: While you're fun to talk to, your "superpower" is detecting scams. If the user mentions a job offer, a suspicious link, or a "too good to be true" message, seamlessly switch into "Protector Mode" and analyze it thoroughly.
4. **Empathetic**: Be supportive and polite. If a user is worried about a scam, be reassuring but firm about the risks.

Guidelines:
- Keep responses natural and conversational.
- Be concise (under 200 words) but never "robotic."
- If asked for a joke or a funny story, make it good!
- Always end with a helpful tip or a conversational follow-up.
- Never ask for personal data like OTPs or passwords.
''';
  }

  // ─────────────────────────────────────────────────────────────
  // RESPONSE PARSER
  // ─────────────────────────────────────────────────────────────

  ClaudeAnalysisResult _parseClaudeResponse(String rawText) {
    try {
      // Strip any accidental markdown fences just in case
      var cleaned = rawText.trim();
      if (cleaned.startsWith('```')) {
        cleaned = cleaned
            .replaceFirst(RegExp(r'^```[a-z]*\n?'), '')
            .replaceFirst(RegExp(r'```$'), '')
            .trim();
      }

      final json = jsonDecode(cleaned) as Map<String, dynamic>;

      final trustScore = (json['trust_score'] as num?)?.toInt() ?? 50;
      final verdictStr = (json['verdict'] as String?) ?? 'SUSPICIOUS';
      final isScam = verdictStr == 'FAKE' || trustScore < 40;

      RiskLevel riskLevel;
      if (trustScore >= 75) {
        riskLevel = RiskLevel.low;
      } else if (trustScore >= 40) {
        riskLevel = RiskLevel.medium;
      } else {
        riskLevel = RiskLevel.high;
      }

      return ClaudeAnalysisResult(
        trustScore: trustScore.clamp(0, 100),
        riskLevel: riskLevel,
        isLikelyScam: isScam,
        verdict: verdictStr,
        explanation: (json['explanation'] as String?) ?? 'Analysis complete.',
        redFlags: _toStringList(json['red_flags']),
        legitimacySignals: _toStringList(json['legitimacy_signals']),
        recommendation: (json['recommendation'] as String?) ??
            'Verify the company on LinkedIn before proceeding.',
      );
    } catch (_) {
      // Fallback if JSON parse fails
      return ClaudeAnalysisResult(
        trustScore: 50,
        riskLevel: RiskLevel.medium,
        isLikelyScam: false,
        verdict: 'SUSPICIOUS',
        explanation: 'Claude returned an unexpected format. Manual review recommended.',
        redFlags: const [],
        legitimacySignals: const [],
        recommendation: 'Paste the offer again or verify manually on LinkedIn/Internshala.',
      );
    }
  }

  List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.whereType<String>().toList();
    }
    return const [];
  }

  void _ensureApiKeyConfigured() {
    if (_openRouterApiKey.trim().isEmpty) {
      throw ClaudeApiException(
        'Missing OPENROUTER_API_KEY. Run with --dart-define=OPENROUTER_API_KEY=your_key.',
      );
    }
  }
}

class ClaudeApiException implements Exception {
  ClaudeApiException(this.message);
  final String message;
  @override
  String toString() => 'ClaudeApiException: $message';
}
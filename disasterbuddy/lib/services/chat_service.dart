import 'dart:convert';
import 'package:disasterbuddy/views/chatting_screen.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static const _apiKey = String.fromEnvironment('ANTHROPIC_API_KEY');
  static const _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const _model = 'claude-sonnet-4-6';
  static const _anthropicVersion = '2023-06-01';
  static const _maxTokens = 1024;

  static const _systemPromptBase =
      "You are Disaster AIDvisor, a warm and concise disaster preparedness assistant for BuildSOS. "
      "Your responses must be short, conversational, and easy to skim. "
      "Default to 2-4 sentences. Only use a bulleted or numbered list when the user explicitly asks for steps, "
      "and even then keep each bullet to one short line. "
      "After giving a quick overview, invite the user to pick what they want to go deeper on "
      "(e.g., \"Want me to walk through the emergency kit next?\"). "
      "Never dump long multi-paragraph responses. Never restate the user's question. "
      "For emergencies, remind the user to call 911. "
      "You are informational only and not a substitute for professional advice.";

  String _languageInstruction(String langCode) {
    switch (langCode) {
      case 'es':
        return " Always respond in Spanish (Español) using a polite, formal register (usted).";
      default:
        return " Always respond in English.";
    }
  }

  Future<String> getChatResponse(
    List<ModelforMyBot> allmessages, {
    String languageCode = 'en',
  }) async {
    if (_apiKey.isEmpty) {
      throw StateError(
        'ANTHROPIC_API_KEY not set. Build with --dart-define=ANTHROPIC_API_KEY=...',
      );
    }

    final systemPrompt = _systemPromptBase + _languageInstruction(languageCode);

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'anthropic-version': _anthropicVersion,
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': _maxTokens,
        'system': systemPrompt,
        'messages': allmessages.map((v) => v.toJson()).toList(),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return (data['content'][0]['text'] as String).trim();
    } else {
      throw Exception(
        'Anthropic request failed (${response.statusCode}): ${utf8.decode(response.bodyBytes)}',
      );
    }
  }
}

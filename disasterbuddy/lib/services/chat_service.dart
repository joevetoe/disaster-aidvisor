import 'dart:convert';
import 'package:disasterbuddy/views/chatting_screen.dart';
import 'package:http/http.dart' as http;

class ChatService {
  String _apiKey =
      'OPENAI_KEY_SCRUBBED';
  static const _baseUrl = 'https://api.openai.com/v1/chat/completions';
  setApiKey(key) {
    _apiKey = key;
  }

  static const _systemPrompt =
      "You are Disaster AIDvisor, a warm and concise disaster preparedness assistant for BuildSOS. "
      "Your responses must be short, conversational, and easy to skim. "
      "Default to 2-4 sentences. Only use a bulleted or numbered list when the user explicitly asks for steps, "
      "and even then keep each bullet to one short line. "
      "After giving a quick overview, invite the user to pick what they want to go deeper on "
      "(e.g., \"Want me to walk through the emergency kit next?\"). "
      "Never dump long multi-paragraph responses. Never restate the user's question. "
      "For emergencies, remind the user to call 911. "
      "You are informational only and not a substitute for professional advice.";

  Future<String> getChatResponse(List<ModelforMyBot> allmessages) async {
    final messagesWithSystem = [
      {'role': 'system', 'content': _systemPrompt},
      ...allmessages.map((v) => v.toJson()),
    ];
    print(jsonEncode(messagesWithSystem));
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': messagesWithSystem,
        'max_tokens': 400,
        'temperature': 0.7,
        'top_p': 1.0,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['choices'][0]['message']['content'].trim());
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('Failed to load response');
    }
  }
}

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

  Future<String> getChatResponse(List<ModelforMyBot> allmessages) async {
    print(jsonEncode(allmessages.map((v) => v.toJson()).toList()));
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': allmessages.map((v) => v.toJson()).toList(),
        // [
        //   {'role': 'system', 'content': 'You are a helpful assistant.'},
        //   {'role': 'user', 'content': prompt},
        // ],
        'max_tokens': 1500, // Adjust this value as needed
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

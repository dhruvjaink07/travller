import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotService {
  final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: 'AIzaSyAvXRt6EbiUyYEwOk9adzLd8gES3WvyHSE');

  Future<String> getResponse(String userQuery) async {
    final content = [Content.text(userQuery)];
    final response = await model.generateContent(content);
    return response.text ?? "Sorry, I couldn't fetch the response.";
  }
}

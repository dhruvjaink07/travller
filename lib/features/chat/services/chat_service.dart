import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotService {
  final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: 'API_KEY');

  Future<String> getResponse(String userQuery,
      {double? latitude, double? longitude}) async {
    String prompt = userQuery;
    if (latitude != null && longitude != null) {
      prompt = "You are a friendly travel assistant. The user is currently at latitude $latitude and longitude $longitude. " +
          "Do NOT mention or return coordinates in your response. Instead, suggest nearby attractions, restaurants, or events as if you are really talking to someone at that location. " +
          "Be conversational and helpful. Here is the user's question: $userQuery";
    }
    final content = [Content.text(prompt)];
    try {
      final response = await model.generateContent(content);
      return response.text ?? "Sorry, I couldn't fetch the response.";
    } catch (e) {
      return "Sorry, the AI service is currently overloaded. Please try again in a few moments.";
    }
  }
}

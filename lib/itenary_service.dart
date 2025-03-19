import 'package:google_generative_ai/google_generative_ai.dart';

Future<String> generateItinerary(
    String destination, String duration, String interests) async {
  final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: 'API KEY');
  String prompt = """
  You are a travel itinerary planner.
  Generate a structured **$duration-day travel itinerary** for a $destination.
  The response should be in **JSON format only**, without any extra text.

  Here’s the required format:

  {
    "destination": "City Name",
    "duration": "X days",
    "itinerary": [
      {
        "day": X,
        "date": "YYYY-MM-DD",
        "events": [
          {
            "time": "HH:MM AM/PM",
            "title": "Event Name",
            "location": "Place Name",
            "coordinates": {
              "lat": 0.0,
              "long": 0.0
            },
            "description": "Brief details about the event",
            "imageUrls": [
              links of lived images if availables and not from wikimedia they are facing server issues
              
            ]
          }
        ]
      }
    ]
  }

  Now, generate an itinerary for **$destination for $duration starting from next month. Include live image URLs for each event location to help visualize the places. Ensure the image URLs are valid and accessible.**
  """;
  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);
  return response.text ?? "Could not generate itinerary.";
}

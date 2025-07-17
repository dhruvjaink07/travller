import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:travller/config.dart';

Future<String> generateItinerary(
    String source, String destination, String duration, String interests,
    {required int numberOfPeople,
    required String currency,
    DateTime? startDate,
    DateTime? endDate}) async {
  const String APIKEY = Config.APIKEY;
  final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: APIKEY);

  final actualStartDate = startDate ?? DateTime.now();
  final actualEndDate =
      endDate ?? actualStartDate.add(Duration(days: int.parse(duration) - 1));

  String prompt = """
  You are a travel itinerary planner.
  Generate a structured **$duration-day travel itinerary** for travel from $source to $destination for $numberOfPeople people.
  The budget should be prepared in $currency.
  The response should be in **JSON format only**, without any extra text.

  Here's the required format:

  {
    "source": "City Name",
    "destination": "City Name",
    "duration": "X days",
    "start_date": "YYYY-MM-DD",
    "end_date": "YYYY-MM-DD",
    "total_budget": "Estimated total budget for the trip in $currency",
    "transportation": [
      {
        "mode": "Transportation mode (e.g., car, train, flight)",
        "details": "Details about the transportation (e.g., flight number, train name)"
      }
    ],
    "accommodation": [
      {
        "name": "Accommodation name",
        "type": "Type of accommodation (e.g., hotel, Airbnb)",
        "address": "Address of the accommodation",
        "price_per_night": "Price per night in $currency"
      }
    ],
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
              "https://example.com/image1.jpg",
              "https://example.com/image2.jpg"
            ]
          }
        ]
      }
    ]
  }

  Now, generate an itinerary for travel from **$source to $destination for $duration days starting from ${DateFormat('yyyy-MM-dd').format(actualStartDate)} to ${DateFormat('yyyy-MM-dd').format(actualEndDate)} for $numberOfPeople people. Include live image URLs for each event location to help visualize the places. Ensure the image URLs are valid and accessible. Also, include the total budget, transportation details, and accommodation suggestions in $currency.**
  """;

  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);
  print(response.text); // Debugging line to check the full response
  return response.text ?? "Could not generate itinerary.";
}

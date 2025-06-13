import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationSuggestions {
  Timer? _debounce; // Timer for debouncing

  Future<List<String>> fetchSuggestions(String input) async {
    if (input.isEmpty) {
      return [];
    }

    final String url =
        "https://nominatim.openstreetmap.org/search?q=$input&format=json";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent':
              'travller-app/1.0 (jaindhruv25006@gmail.com)', // Replace with your email
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((item) => item['display_name'] as String).toList();
      } else {
        print("Failed to fetch suggestions: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
      return [];
    }
  }

  void debounce(String input, Function(List<String>) callback) {
    // Cancel the previous debounce timer if it's still active
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new debounce timer
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final suggestions = await fetchSuggestions(input);
      callback(suggestions); // Pass the suggestions back to the UI
    });
  }

  void dispose() {
    _debounce?.cancel(); // Cancel the debounce timer when no longer needed
  }
}

import 'package:flutter/material.dart';
import 'package:travller/itenary_service.dart';
import 'package:travller/itenary_display_screen.dart';
import 'dart:convert';

class ItineraryScreen extends StatefulWidget {
  @override
  _ItineraryScreenState createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _interestsController = TextEditingController();
  bool _isLoading = false; // Track loading state

  void generatePlan() async {
    setState(() {
      _isLoading = true; // Show loader
    });

    try {
      String response = await generateItinerary(
        _destinationController.text,
        _durationController.text,
        _interestsController.text,
      );

      // Log the response for debugging
      print("API Response: $response");

      // Remove Markdown code block delimiters
      response = response.replaceAll(RegExp(r'```json|```'), '');

      // Ensure the response is valid JSON
      Map<String, dynamic> itineraryData = jsonDecode(response);

      setState(() {
        _isLoading = false; // Hide loader
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ItineraryDisplayScreen(itinerary: itineraryData),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide loader
      });

      // Handle JSON parsing error
      print("Error parsing JSON: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Failed to generate itinerary. Please try again."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Itinerary Generator")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(), // Show loader
              )
            else
              Column(
                children: [
                  TextField(
                      controller: _destinationController,
                      decoration: InputDecoration(labelText: "Destination")),
                  TextField(
                      controller: _durationController,
                      decoration:
                          InputDecoration(labelText: "Duration (days)")),
                  TextField(
                      controller: _interestsController,
                      decoration: InputDecoration(
                          labelText: "Interests (e.g., beaches, adventure)")),
                  SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: generatePlan,
                      child: Text("Generate Itinerary")),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

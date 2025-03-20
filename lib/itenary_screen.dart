import 'package:flutter/material.dart';
import 'package:travller/itenary_service.dart';
import 'package:travller/itenary_display_screen.dart';
import 'dart:convert';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});

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
          backgroundColor: Colors.purple,
          title: const Text("Error",
              style:
                  TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
          content: const Text("Failed to generate itinerary. Please try again.",
              style:
                  TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK",
                  style: TextStyle(
                      color: Colors.white, fontStyle: FontStyle.italic)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.purple.withOpacity(0.1),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 2.0),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 2.5),
            borderRadius: BorderRadius.circular(10),
          ),
          labelStyle:
              TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Itinerary Generator",
              style: TextStyle(fontStyle: FontStyle.italic)),
          backgroundColor: Colors.purple,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          color: Colors.deepPurple[900],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                      color: Colors.white), // Show loader
                )
              else
                Column(
                  children: [
                    TextField(
                      controller: _destinationController,
                      decoration:
                          const InputDecoration(labelText: "Destination"),
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _durationController,
                      decoration:
                          const InputDecoration(labelText: "Duration (days)"),
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _interestsController,
                      decoration: const InputDecoration(
                          labelText: "Interests (e.g., beaches, adventure)"),
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: generatePlan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      child: const Text("Generate Itinerary",
                          style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic)),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

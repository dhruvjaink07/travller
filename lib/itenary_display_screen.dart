import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'map_screen.dart';

class ItineraryDisplayScreen extends StatelessWidget {
  final Map<String, dynamic> itinerary;

  const ItineraryDisplayScreen({super.key, required this.itinerary});

  List<LatLng> extractCoordinates() {
    List<LatLng> coordinates = [];
    for (var day in itinerary['itinerary']) {
      for (var event in day['events']) {
        coordinates.add(LatLng(
          event['coordinates']['lat'],
          event['coordinates']['long'],
        ));
      }
    }
    return coordinates;
  }

  List<Map<String, dynamic>> extractDetails() {
    List<Map<String, dynamic>> details = [];
    for (var day in itinerary['itinerary']) {
      for (var event in day['events']) {
        details.add({
          'title': event['title'],
          'time': event['time'],
          'location': event['location'],
          'description': event['description'],
        });
      }
    }
    return details;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Itinerary Details",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.purple,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.purple.shade700,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.purple.shade700, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Destination: ${itinerary['destination']}",
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.purple),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Duration: ${itinerary['duration']}",
                            style: TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                color: Colors.purple),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...itinerary['itinerary'].map<Widget>((day) {
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        side:
                            BorderSide(color: Colors.purple.shade700, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Day ${day['day']}: ${day['date']}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.deepPurple),
                            ),
                            const Divider(),
                            ...day['events'].map<Widget>((event) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.event,
                                          color: Colors.purple),
                                      title: Text(
                                        event['title'],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.purpleAccent),
                                      ),
                                    ),
                                    Text("Time: ${event['time']}",
                                        style: const TextStyle(
                                            color: Colors.purpleAccent)),
                                    Text("Location: ${event['location']}",
                                        style: const TextStyle(
                                            color: Colors.purple)),
                                    Text(
                                      "Coordinates: (${event['coordinates']['lat']}, ${event['coordinates']['long']})",
                                      style: TextStyle(color: Colors.grey[400]),
                                    ),
                                    Text(
                                      "Description: ${event['description']}",
                                      style: TextStyle(color: Colors.grey[400]),
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                List<LatLng> coordinates = extractCoordinates();
                List<Map<String, dynamic>> details = extractDetails();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MapScreen(coordinates: coordinates, details: details),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.purple.shade900, width: 2),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: const Text(
                "View on Map",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.purple.shade900,
    );
  }
}

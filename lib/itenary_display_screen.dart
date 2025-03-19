import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'map_screen.dart';

class ItineraryDisplayScreen extends StatelessWidget {
  final Map<String, dynamic> itinerary;

  ItineraryDisplayScreen({required this.itinerary});

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
      appBar: AppBar(title: Text("Itinerary Details")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Display destination and duration
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Destination: ${itinerary['destination']}",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Duration: ${itinerary['duration']}",
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Display each day's itinerary
                  ...itinerary['itinerary'].map<Widget>((day) {
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Day ${day['day']}: ${day['date']}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Divider(),
                            ...day['events'].map<Widget>((event) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading:
                                          Icon(Icons.event, color: Colors.blue),
                                      title: Text(
                                        event['title'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Time: ${event['time']}"),
                                          Text(
                                              "Location: ${event['location']}"),
                                          Text(
                                            "Coordinates: (${event['coordinates']['lat']}, ${event['coordinates']['long']})",
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ),
                                          Text(
                                              "Description: ${event['description']}"),
                                        ],
                                      ),
                                    ),
                                    Divider(),
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
                List<Map<String, dynamic>> details =
                    extractDetails(); // Extract details for each event
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MapScreen(coordinates: coordinates, details: details),
                  ),
                );
              },
              child: Text("View on Map"),
            ),
          ],
        ),
      ),
    );
  }
}

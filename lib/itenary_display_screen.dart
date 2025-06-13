import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'map_screen.dart';
import 'package:travller/theme/app_colors.dart'; // Import the color palette

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
        title: const Text("Itinerary Details"),
        backgroundColor: AppColors.primary, // Use primary color for the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Display destination, duration, and date range
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
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
                              color: AppColors.primary, // Use primary color
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Duration: ${itinerary['duration']}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: AppColors
                                  .textPrimary, // Use secondary text color
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Date Range: ${itinerary['start_date']} - ${itinerary['end_date']}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors
                                  .textSecondary, // Use hint text color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Display total budget
                  if (itinerary.containsKey('total_budget'))
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          "Total Budget: ${itinerary['total_budget']}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary, // Use primary color
                          ),
                        ),
                      ),
                    ),
                  // Display transportation details
                  if (itinerary.containsKey('transportation'))
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Transportation",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary, // Use primary color
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...itinerary['transportation']
                                .map<Widget>((transport) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "→ ${transport['mode']}: ${transport['details']}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        AppColors.textPrimary, // Use text color
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  // Display accommodation details
                  if (itinerary.containsKey('accommodation'))
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Accommodation",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary, // Use primary color
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...itinerary['accommodation']
                                .map<Widget>((accommodation) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name: ${accommodation['name']}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      "Type: ${accommodation['type']}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      "Address: ${accommodation['address']}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      "Price per Night: ${accommodation['price_per_night']}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  // Display each day's itinerary
                  ...itinerary['itinerary'].map<Widget>((day) {
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
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
                                color: AppColors.primary, // Use primary color
                              ),
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
                                      leading: const Icon(
                                        Icons.event,
                                        color: AppColors
                                            .accent, // Use accent color
                                      ),
                                      title: Text(
                                        event['title'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors
                                              .textPrimary, // Use primary text color
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Time: ${event['time']}",
                                            style: const TextStyle(
                                              color: AppColors
                                                  .textPrimary, // Use secondary text color
                                            ),
                                          ),
                                          Text(
                                            "Location: ${event['location']}",
                                            style: const TextStyle(
                                              color: AppColors
                                                  .textPrimary, // Use secondary text color
                                            ),
                                          ),
                                          Text(
                                            "Coordinates: (${event['coordinates']['lat']}, ${event['coordinates']['long']})",
                                            style: const TextStyle(
                                              color: AppColors
                                                  .textSecondary, // Use hint text color
                                            ),
                                          ),
                                          Text(
                                            "Description: ${event['description']}",
                                            style: const TextStyle(
                                              color: AppColors
                                                  .textPrimary, // Use secondary text color
                                            ),
                                          ),
                                        ],
                                      ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.primary, // Use primary color for the button
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "View on Map",
                style: TextStyle(
                  color: AppColors.background, // Use background color for text
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:travller/theme/app_colors.dart'; // Import the color palette

class MapScreen extends StatefulWidget {
  final List<LatLng> coordinates;
  final List<Map<String, dynamic>> details; // Additional details for markers

  const MapScreen(
      {super.key, required this.coordinates, required this.details});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> markers = [];
  bool _showList = true; // Flag to toggle the visibility of the list

  @override
  void initState() {
    super.initState();
    updateMarkers(widget.coordinates, widget.details);
  }

  void updateMarkers(
      List<LatLng> coordinates, List<Map<String, dynamic>> details) {
    setState(() {
      markers = List.generate(coordinates.length, (index) {
        return Marker(
          point: coordinates[index],
          width: 80,
          height: 80,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.background, // Dialog background
                  title: Text(
                    details[index]['title'],
                    style: const TextStyle(
                      color: AppColors.primary, // Title color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Time: ${details[index]['time']}",
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      Text(
                        "Location: ${details[index]['location']}",
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      Text(
                        "Description: ${details[index]['description']}",
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      Text(
                        "Coordinates: (${coordinates[index].latitude}, ${coordinates[index].longitude})",
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "Close",
                        style: TextStyle(color: AppColors.accent),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: const Icon(
              Icons.location_on,
              color: AppColors.accent, // Marker color
              size: 40,
            ),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        backgroundColor: AppColors.primary, // AppBar background color
        actions: [
          IconButton(
            icon: Icon(
              _showList ? Icons.fullscreen : Icons.fullscreen_exit,
              color: AppColors.background,
            ),
            onPressed: () {
              setState(() {
                _showList = !_showList; // Toggle the visibility of the list
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: _showList
                ? 2
                : 1, // Adjust the map size based on the list visibility
            child: FlutterMap(
              options: MapOptions(
                initialCenter: markers.isNotEmpty
                    ? markers[0].point
                    : const LatLng(20.5937, 78.9629),
                maxZoom: 50.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          ),
          if (_showList)
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: widget.details.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    color: AppColors.background, // Card background color
                    shadowColor: AppColors.shadow, // Card shadow color
                    child: ListTile(
                      leading: const Icon(
                        Icons.place,
                        color: AppColors.accent, // Icon color
                      ),
                      title: Text(
                        widget.details[index]['title'],
                        style: const TextStyle(
                          color: AppColors.textPrimary, // Title text color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Time: ${widget.details[index]['time']}",
                            style:
                                const TextStyle(color: AppColors.textSecondary),
                          ),
                          Text(
                            "Location: ${widget.details[index]['location']}",
                            style:
                                const TextStyle(color: AppColors.textSecondary),
                          ),
                          Text(
                            "Coordinates: (${widget.coordinates[index].latitude}, ${widget.coordinates[index].longitude})",
                            style:
                                const TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

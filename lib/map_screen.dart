import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
                  title: Text(details[index]['title']),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Time: ${details[index]['time']}"),
                      Text("Location: ${details[index]['location']}"),
                      Text("Description: ${details[index]['description']}"),
                      Text(
                          "Coordinates: (${coordinates[index].latitude}, ${coordinates[index].longitude})"),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              );
            },
            child: const Icon(Icons.location_on, color: Colors.red, size: 40),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map View')),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                  initialCenter: markers.isNotEmpty
                      ? markers[0].point
                      : const LatLng(20.5937, 78.9629),
                  maxZoom: 50.0),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                  tileProvider:
                      NetworkTileProvider(), // Use the default network tile provider
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.details.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    leading: const Icon(Icons.place, color: Colors.blue),
                    title: Text(widget.details[index]['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Time: ${widget.details[index]['time']}"),
                        Text("Location: ${widget.details[index]['location']}"),
                        Text(
                            "Coordinates: (${widget.coordinates[index].latitude}, ${widget.coordinates[index].longitude})"),
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

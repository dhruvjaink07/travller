import 'package:flutter/material.dart';
import 'package:travller/chat_screen.dart';
import 'package:travller/itenary_screen.dart';
import 'package:travller/theme/app_colors.dart'; // Import the AppColors class

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Traveller's Hub"),
        backgroundColor: AppColors.primary, // Use primary color
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/travel-background.png"),
                  fit: BoxFit.fitHeight),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to Traveller's Hub",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.background, // Use textPrimary color
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: AppColors.shadow, // Use shadow color
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ItineraryScreen()),
                    );
                  },
                  icon: const Icon(Icons.map, color: AppColors.background),
                  label: const Text(
                    "Itinerary Generator",
                    style: TextStyle(fontSize: 18, color: AppColors.background),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors
                        .buttonBackground, // Use buttonBackground color
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen()),
                    );
                  },
                  icon: const Icon(Icons.chat, color: AppColors.background),
                  label: const Text(
                    "Travel Assistant",
                    style: TextStyle(fontSize: 18, color: AppColors.background),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors
                        .buttonBackground, // Use buttonBackground color
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

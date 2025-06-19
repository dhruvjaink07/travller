import 'package:flutter/material.dart';
import 'package:travller/features/chat/screens/chat_screen.dart';
import 'package:travller/features/itinerary/screens/itenary_screen.dart';
import 'package:travller/app/theme/app_colors.dart'; // Import the AppColors class

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    final contentWidth = isWide ? 400.0 : double.infinity;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Traveller's Hub"),
        backgroundColor: AppColors.primary, // Use primary color
      ),
      body: Stack(
        children: [
          // Optional: faint full-page background image
          Positioned.fill(
            child: Opacity(
              opacity: 0.08, // Very subtle
              child: Image.asset(
                "assets/travel-background.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content
          Center(
            child: Container(
              width: 420,
              height: 600,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: const DecorationImage(
                  image: AssetImage("assets/travel-background.png"),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.black.withOpacity(0.35),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome to Traveller's Hub",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black54,
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
                              builder: (context) => const ItineraryScreen()),
                        );
                      },
                      icon: const Icon(Icons.map, color: Colors.white),
                      label: const Text(
                        "Itinerary Generator",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBackground,
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
                          MaterialPageRoute(
                              builder: (context) => const ChatScreen()),
                        );
                      },
                      icon: const Icon(Icons.chat, color: Colors.white),
                      label: const Text(
                        "Travel Assistant",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBackground,
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
            ),
          ),
        ],
      ),
    );
  }
}

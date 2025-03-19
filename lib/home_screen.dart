import 'package:flutter/material.dart';
import 'package:travller/chat_screen.dart';
import 'package:travller/itenary_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ItineraryScreen()),
                  );
                },
                child: Text("Itinerary Generator"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen()), // Assuming you have a ChatbotScreen
                  );
                },
                child: Text("Chatbot"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:travller/home_screen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List<String> images = ["TRAVELLERIMG.png"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: images.length,
        itemBuilder: (_, index) {
          return Stack(
            children: [
              // Background Image
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("img/${images[index]}"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Positioned Text with Border Effect
              Positioned(
                top: 150,
                left: 20,
                right: 150, // Ensuring text doesn't take full width
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _borderedTextB("Traveller", 32, FontWeight.w400),
                    const SizedBox(height: 5),
                    _borderedTexts(
                        "Chase the unthinkable!!", 26, FontStyle.italic),
                    const SizedBox(height: 10),
                    _borderedText(
                      "Adventure awaits—go find it!",
                      16,
                      FontWeight.normal,
                    ),
                  ],
                ),
              ),

              // Positioned Icon Button
              Positioned(
                bottom: 50,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                  iconSize: 30,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Function to create bordered text
  Widget _borderedText(String text, double fontSize, FontWeight fontWeight) {
    return Stack(
      children: [
        // Black stroke text
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = Colors.black, // Border color
          ),
        ),
        // White filled text
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: Colors.white, // Fill color
          ),
        ),
      ],
    );
  }
}

Widget _borderedTextB(String text, double fontSize, FontWeight fontWeight) {
  return Stack(
    children: [
      // Black stroke text
      Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..color = Colors.black, // Border color
        ),
      ),
      // White filled text
      Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Colors.white, // Fill color
        ),
      ),
    ],
  );
}

Widget _borderedTexts(String text, double fontSize, FontStyle fontStyle) {
  return Stack(
    children: [
      // Black stroke text
      Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontStyle: fontStyle,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..color = Colors.black, // Border color
        ),
      ),
      // White filled text
      Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontStyle: fontStyle,
          color: Colors.white, // Fill color
        ),
      ),
    ],
  );
}

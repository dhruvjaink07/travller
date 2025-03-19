import 'package:flutter/material.dart';
import 'package:travller/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatbotService chatbot = ChatbotService();
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  void sendMessage() async {
    String userMessage = _controller.text;
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": userMessage});
    });

    _controller.clear();
    String botResponse = await chatbot.getResponse(userMessage);

    setState(() {
      messages.add({"role": "bot", "text": botResponse});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Travel Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg["role"] == "user"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: msg["role"] == "user" ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg["text"]!,
                        style: TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Ask a question..."),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

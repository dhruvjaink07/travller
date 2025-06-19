import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travller/features/chat/providers/chat_provider.dart';
import 'package:travller/app/theme/app_colors.dart';
import 'package:travller/features/location/providers/location_provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  final List<String> quickPrompts = [
    "What are the best places to visit near me right now?",
    "Suggest a good restaurant nearby.",
    "Are there any events happening close to me?",
    "What’s a hidden gem in this area?",
    "Where can I get good coffee nearby?"
  ];

  void sendMessage(String userMessage) async {
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": userMessage});
    });

    _controller.clear();

    final chatbot = ref.read(chatbotServiceProvider);

    // Get the latest location
    final locationAsync = ref.read(locationProvider);

    double? latitude;
    double? longitude;

    locationAsync.whenData((location) {
      latitude = location?.latitude;
      longitude = location?.longitude;
    });

    // Wait for location if needed
    if (latitude == null || longitude == null) {
      setState(() {
        messages.add(
            {"role": "bot", "text": "Fetching your location, please wait..."});
      });
      final location = await ref.read(locationProvider.future);
      latitude = location?.latitude;
      longitude = location?.longitude;
    }

    String botResponse = await chatbot.getResponse(
      userMessage,
      latitude: latitude,
      longitude: longitude,
    );

    setState(() {
      messages.add({"role": "bot", "text": botResponse});
    });
  }

  Widget _buildChatBubble(Map<String, String> msg) {
    final isUser = msg["role"] == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isUser
            ? Text(
                msg["text"] ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
              )
            : MarkdownBody(
                data: msg["text"] ?? "",
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    height: 1.4,
                  ),
                  a: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTapLink: (text, href, title) {
                  if (href != null) {
                    // You can use url_launcher to open links
                  }
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final chatCardWidth = isWide ? 650.0 : double.infinity;
    final chatCardHeight = isWide ? 700.0 : double.infinity;
    final chatCardMargin =
        isWide ? const EdgeInsets.symmetric(vertical: 40) : EdgeInsets.zero;
    final chatCardPadding = isWide
        ? const EdgeInsets.symmetric(horizontal: 32, vertical: 24)
        : const EdgeInsets.symmetric(horizontal: 8, vertical: 8);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Travel Chatbot"),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        color: const Color(0xFFF8F0F8),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            width: chatCardWidth,
            height: chatCardHeight,
            margin: chatCardMargin,
            decoration: isWide
                ? BoxDecoration(
                    color: Colors.white.withOpacity(0.98),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  )
                : null,
            child: Padding(
              padding: chatCardPadding,
              child: Column(
                children: [
                  // Chat Messages
                  Expanded(
                    child: messages.isEmpty
                        ? Center(
                            child: Text(
                              "Start a conversation!",
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 20,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final msg = messages[index];
                              return _buildChatBubble(msg);
                            },
                          ),
                  ),
                  // Quick Prompts (wrap to new line if needed)
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: quickPrompts.map((prompt) {
                        return ElevatedButton(
                          onPressed: () => sendMessage(prompt),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.textSecondary,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(prompt,
                              style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                    ),
                  ),
                  // Input Field
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: "Ask a question...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: AppColors.background,
                            ),
                            onSubmitted: (value) => sendMessage(value),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => sendMessage(_controller.text),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.all(14),
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(Icons.send,
                              color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travller/features/chat/services/chat_service.dart';

final chatbotServiceProvider =
    Provider<ChatbotService>((ref) => ChatbotService());

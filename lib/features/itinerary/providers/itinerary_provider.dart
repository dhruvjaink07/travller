import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

import 'package:travller/features/itinerary/services/itenary_service.dart';

final itineraryProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, ItineraryParams>((ref, params) async {
  final response = await generateItinerary(
    params.source,
    params.destination,
    params.duration,
    params.interests,
    numberOfPeople: params.numberOfPeople,
    startDate: params.startDate,
    endDate: params.endDate,
    currency: params.currency,
  );
  return response.isNotEmpty
      ? Map<String, dynamic>.from(
          jsonDecode(response.replaceAll(RegExp(r'```json|```'), '')))
      : {};
});

class ItineraryParams {
  final String source;
  final String destination;
  final String duration;
  final String interests;
  final int numberOfPeople;
  final DateTime? startDate;
  final DateTime? endDate;
  final String currency;

  ItineraryParams({
    required this.source,
    required this.destination,
    required this.duration,
    required this.interests,
    required this.numberOfPeople,
    required this.startDate,
    required this.endDate,
    required this.currency,
  });
}

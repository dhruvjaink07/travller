import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

final locationProvider = FutureProvider<LocationData?>((ref) async {
  final service = Location();
  return await service.getLocation();
});

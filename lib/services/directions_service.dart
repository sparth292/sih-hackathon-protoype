import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteResult {
  final List<LatLng> polylinePoints;
  final int distanceMeters;
  final int durationSeconds;

  const RouteResult({
    required this.polylinePoints,
    required this.distanceMeters,
    required this.durationSeconds,
  });
}

class DirectionsService {
  DirectionsService(this.apiKey);
  final String apiKey;

  // Google Routes API - Compute Routes v2
  Future<RouteResult?> fetchRoute({
    required LatLng origin,
    required LatLng destination,
    String travelMode = 'DRIVE',
  }) async {
    final url = Uri.parse('https://routes.googleapis.com/directions/v2:computeRoutes');
    final headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask': 'routes.distanceMeters,routes.duration,routes.polyline.encodedPolyline',
    };
    final body = jsonEncode({
      'origin': {
        'location': {'latLng': {'latitude': origin.latitude, 'longitude': origin.longitude}}
      },
      'destination': {
        'location': {'latLng': {'latitude': destination.latitude, 'longitude': destination.longitude}}
      },
      'travelMode': travelMode,
      'routingPreference': 'TRAFFIC_AWARE',
    });

    final resp = await http.post(url, headers: headers, body: body);
    if (resp.statusCode != 200) return null;
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final routes = data['routes'] as List?;
    if (routes == null || routes.isEmpty) return null;
    final route = routes.first as Map<String, dynamic>;
    final distance = route['distanceMeters'] as int? ?? 0;
    final durationStr = route['duration'] as String? ?? '0s';
    final durationSec = _parseDurationToSeconds(durationStr);
    final encoded = (route['polyline'] as Map<String, dynamic>?)?['encodedPolyline'] as String?;
    final points = encoded != null ? _decodePolyline(encoded) : <LatLng>[];
    return RouteResult(polylinePoints: points, distanceMeters: distance, durationSeconds: durationSec);
  }

  int _parseDurationToSeconds(String duration) {
    // e.g., "123s" or "1.2s"
    final s = duration.replaceAll('s', '');
    return double.tryParse(s)?.round() ?? 0;
  }

  // Polyline6 decoder compatible with Google Routes API; works for 5/6 precision
  List<LatLng> _decodePolyline(String encoded) {
    int index = 0;
    int lat = 0;
    int lng = 0;
    final List<LatLng> coordinates = [];

    while (index < encoded.length) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      // precision 1e-5 (works fine for 1e-6 as well in practice)
      final latitude = lat / 1e5;
      final longitude = lng / 1e5;
      coordinates.add(LatLng(latitude, longitude));
    }
    return coordinates;
  }
}



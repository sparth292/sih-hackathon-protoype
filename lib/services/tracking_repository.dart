import 'package:supabase_flutter/supabase_flutter.dart';

class Pandal {
  final String id;
  final String name;
  final double? aagmanLat;
  final double? aagmanLng;
  final double? visarjanLat;
  final double? visarjanLng;

  const Pandal({
    required this.id,
    required this.name,
    required this.aagmanLat,
    required this.aagmanLng,
    required this.visarjanLat,
    required this.visarjanLng,
  });

  factory Pandal.fromMap(Map<String, dynamic> map) {
    return Pandal(
      id: map['id'] as String,
      name: map['name'] as String,
      aagmanLat: (map['aagman_destination_lat'] as num?)?.toDouble(),
      aagmanLng: (map['aagman_destination_lng'] as num?)?.toDouble(),
      visarjanLat: (map['visarjan_destination_lat'] as num?)?.toDouble(),
      visarjanLng: (map['visarjan_destination_lng'] as num?)?.toDouble(),
    );
  }
}

class MurtiLocation {
  final double latitude;
  final double longitude;
  final String status;
  final DateTime updatedAt;

  const MurtiLocation({
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.updatedAt,
  });

  factory MurtiLocation.fromMap(Map<String, dynamic> map) {
    return MurtiLocation(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      status: map['status'] as String,
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}

class TrackingRepository {
  TrackingRepository._();
  static final TrackingRepository instance = TrackingRepository._();

  SupabaseClient get _client => Supabase.instance.client;

  Future<List<Pandal>> fetchPandals() async {
    final response = await _client
        .from('pandals')
        .select('id, name, aagman_destination_lat, aagman_destination_lng, visarjan_destination_lat, visarjan_destination_lng')
        .eq('is_active', true);

    final List data = response;
    return data.map((e) => Pandal.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<MurtiLocation?> fetchCurrentMurtiLocation({
    required String pandalId,
    required String mode, // 'aagman' | 'visarjan'
  }) async {
    final response = await _client
        .from('murti_current_locations')
        .select('latitude, longitude, status, updated_at')
        .eq('pandal_id', pandalId)
        .eq('mode', mode)
        .maybeSingle();

    if (response == null) return null;
    return MurtiLocation.fromMap(response);
  }

  Future<void> upsertMockMurtiLocation({
    required String pandalId,
    required String mode,
    required double latitude,
    required double longitude,
    String status = 'ongoing',
  }) async {
    try {
      await _client.from('murti_current_locations').upsert({
        'pandal_id': pandalId,
        'mode': mode,
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'pandal_id,mode');
    } catch (e) {
      rethrow;
    }
  }
}



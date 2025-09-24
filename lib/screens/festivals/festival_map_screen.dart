import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math.dart' as v_math;

class FestivalMapScreen extends StatefulWidget {
  final Map<String, dynamic> festival;
  final GeoPoint? destination;

  const FestivalMapScreen({
    Key? key,
    required this.festival,
    this.destination,
  }) : super(key: key);

  @override
  _FestivalMapScreenState createState() => _FestivalMapScreenState();
}

class _FestivalMapScreenState extends State<FestivalMapScreen> {
  late MapController _mapController;
  bool _isLoading = true;
  String _distance = '';
  GeoPoint? _currentPosition;
  bool _hasLocationPermission = false;

  late GeoPoint _destination;

  @override
  void initState() {
    super.initState();
    
    // Get coordinates from the festival data if available
    if (widget.festival['latitude'] != null && widget.festival['longitude'] != null) {
      _destination = GeoPoint(
        latitude: widget.festival['latitude'] as double,
        longitude: widget.festival['longitude'] as double,
      );
    } else {
      // Fallback to Mumbai center if no coordinates are provided
      _destination = widget.destination ?? 
          GeoPoint(latitude: 19.0760, longitude: 72.8777);
    }
    
    _mapController = MapController.withPosition(initPosition: _destination);
    _checkLocationPermission();
    _initMap();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initMap() async {
    await _checkLocationPermission();

    if (_hasLocationPermission) {
      await _getCurrentLocation();
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkLocationPermission() async {
    try {
      var status = await Permission.location.status;

      if (status.isDenied || status.isRestricted) {
        status = await Permission.location.request();
      }

      if (mounted) {
        setState(() {
          _hasLocationPermission = status.isGranted;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error checking location permission')),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enable location services')),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final location = GeoPoint(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (mounted) {
        setState(() => _currentPosition = location);
        // Update map markers after map is ready
        _updateMapMarkers();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get current location')),
        );
      }
    }
  }

  Future<void> _updateMapMarkers() async {
    if (_currentPosition == null) return;
    if (!mounted) return;

    try {
      // Clear existing markers and roads
      await _mapController.clearAllRoads();

      // Add current location marker
      await _mapController.addMarker(
        _currentPosition!,
        markerIcon: MarkerIcon(
          icon: const Icon(
            Icons.location_pin,
            color: Colors.blue,
            size: 48,
          ),
        ),
      );

      // Add destination marker
      await _mapController.addMarker(
        _destination,
        markerIcon: MarkerIcon(
          icon: const Icon(
            Icons.celebration,
            color: Colors.red,
            size: 48,
          ),
        ),
      );

      // Draw route between points
      await _drawRoute();

      // Calculate and update distance
      final distance = _calculateDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        _destination.latitude,
        _destination.longitude,
      );

      if (mounted) {
        setState(() {
          _distance = '${(distance / 1000).toStringAsFixed(1)} km';
        });
      }

      // Create a bounding box that includes both points with padding
      final minLat = min(_currentPosition!.latitude, _destination.latitude);
      final maxLat = max(_currentPosition!.latitude, _destination.latitude);
      final minLon = min(_currentPosition!.longitude, _destination.longitude);
      final maxLon = max(_currentPosition!.longitude, _destination.longitude);
      
      // Add some padding to the bounding box
      final padding = 0.01; // ~1km at equator
      
      // Zoom to show both locations with padding
      await _mapController.zoomToBoundingBox(
        BoundingBox(
          north: maxLat + padding,
          east: maxLon + padding,
          south: minLat - padding,
          west: minLon - padding,
        ),
        paddinInPixel: 100,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating map: $e')),
        );
      }
    }
  }

  Future<void> _drawRoute() async {
    if (_currentPosition == null) return;

    try {
      await _mapController.drawRoad(
        _currentPosition!,
        _destination,
        roadOption: const RoadOption(
          roadColor: Colors.blue,
          roadWidth: 5,
          zoomInto: true,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not draw route')),
        );
      }
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // meters

    final dLat = v_math.radians(lat2 - lat1);
    final dLon = v_math.radians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(v_math.radians(lat1)) *
            cos(v_math.radians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.festival['name'] ?? 'Festival Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
            tooltip: 'My Location',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                OSMFlutter(
                  controller: _mapController,
                  osmOption: OSMOption(
                    userTrackingOption: UserTrackingOption(
                      enableTracking: _hasLocationPermission,
                      unFollowUser: false,
                    ),
                    zoomOption: ZoomOption(
                      initZoom: 14,
                      minZoomLevel: 5,
                      maxZoomLevel: 19,
                      stepZoom: 1.0,
                    ),
                    userLocationMarker: UserLocationMaker(
                      personMarker: MarkerIcon(
                        icon: const Icon(
                          Icons.location_pin,
                          color: Colors.blue,
                          size: 48,
                        ),
                      ),
                      directionArrowMarker: MarkerIcon(
                        icon: const Icon(
                          Icons.arrow_circle_up,
                          color: Colors.blue,
                          size: 48,
                        ),
                      ),
                    ),
                    roadConfiguration: RoadOption(
                      roadColor: Colors.blue,
                      roadWidth: 5,
                    ),
                  ),
                  onMapIsReady: (isReady) {
                    if (isReady && _currentPosition != null) {
                      _updateMapMarkers();
                    }
                  },
                ),
                if (_distance.isNotEmpty)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Distance to ${widget.festival['name'] ?? 'destination'}:',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _distance,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (!_hasLocationPermission)
                            ElevatedButton(
                              onPressed: _checkLocationPermission,
                              child: const Text('Enable Location'),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

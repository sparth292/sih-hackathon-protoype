import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher_string.dart';

class GoogleFestivalMapScreen extends StatefulWidget {
  final Map<String, dynamic> festival;
  final LatLng? destination;

  const GoogleFestivalMapScreen({
    Key? key,
    required this.festival,
    this.destination,
  }) : super(key: key);

  @override
  _GoogleFestivalMapScreenState createState() => _GoogleFestivalMapScreenState();
}

class _GoogleFestivalMapScreenState extends State<GoogleFestivalMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;
  bool _isLoading = true;
  String _distance = '';
  String _duration = '';
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  final String _googleMapsApiKey = 'AIzaSyBEijp-wp_aSXYvb1lGLQ84xd7yhTME5II';

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    }
    _getCurrentLocation();
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

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      _updateMap();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not get current location')),
      );
    }
  }

  Future<void> _updateMap() async {
    if (_currentPosition == null) return;

    final LatLng destination = widget.destination ?? 
        LatLng(
          widget.festival['latitude'] ?? 19.0760,
          widget.festival['longitude'] ?? 72.8777,
        );

    // Add markers
    final currentMarker = Marker(
      markerId: const MarkerId('currentLocation'),
      position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      infoWindow: const InfoWindow(title: 'Your Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    final destinationMarker = Marker(
      markerId: const MarkerId('destination'),
      position: destination,
      infoWindow: InfoWindow(title: widget.festival['name'] ?? 'Destination'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers = {currentMarker, destinationMarker};
    });

    // Get route
    await _getRoute(
      LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      destination,
    );

    // Update camera to show both points
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        _boundsFromLatLngList([
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          destination,
        ]),
        100, // padding
      ),
    );
  }

  Future<void> _getRoute(LatLng origin, LatLng destination) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_googleMapsApiKey&mode=driving',
      );

      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        final points = data['routes'][0]['overview_polyline']['points'];
        final distance = data['routes'][0]['legs'][0]['distance']['text'];
        final duration = data['routes'][0]['legs'][0]['duration']['text'];

        setState(() {
          _distance = distance;
          _duration = duration;
          _polylines = {
            Polyline(
              polylineId: const PolylineId('route'),
              points: _convertToLatLng(_decodePoly(points)),
              color: Colors.blue,
              width: 5,
            ),
          };
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not fetch route')),
        );
      }
    }
  }

  List<LatLng> _decodePoly(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng p = LatLng(lat / 1E5, lng / 1E5);
      poly.add(p);
    }
    return poly;
  }

  List<LatLng> _convertToLatLng(List<LatLng> points) {
    return points;
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  Future<void> _openInMaps() async {
    final lat = widget.festival['latitude'];
    final lng = widget.festival['longitude'];
    if (lat == null || lng == null) return;
    
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.festival['name'] ?? 'Festival Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.directions),
            onPressed: _openInMaps,
            tooltip: 'Open in Google Maps',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _currentPosition?.latitude ?? 19.0760,
                      _currentPosition?.longitude ?? 72.8777,
                    ),
                    zoom: 14,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                if (_distance.isNotEmpty && _duration.isNotEmpty)
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Distance to ${widget.festival['name'] ?? 'destination'}:',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$_distance • $_duration',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _getCurrentLocation,
                            tooltip: 'Refresh Location',
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

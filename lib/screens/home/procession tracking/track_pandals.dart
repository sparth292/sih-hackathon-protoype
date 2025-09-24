import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../services/tracking_repository.dart';
import '../../../services/directions_service.dart';

class MapSample extends StatefulWidget {
  final Pandal pandal;
  final String mode; // 'aagman' | 'visarjan'

  const MapSample({super.key, required this.pandal, required this.mode});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  final Set<Marker> _markers = {};
  Timer? _pollTimer;
  Position? _userPosition;
  MurtiLocation? _murtiLocation;
  final _repo = TrackingRepository.instance;
  DateTime? _lastUpdateTime;
  final _directions = DirectionsService('AIzaSyBEijp-wp_aSXYvb1lGLQ84xd7yhTME5II');
  final Set<Polyline> _polylines = {};
  static const String _routePolylineId = 'route';
  static const String _pandalRoutePolylineId = 'pandalRoute';
  bool _showRoute = true;
  bool _routeToDestination = false; // false: Murti->User, true: Murti->Destination
  int? _routeDistanceMeters;
  int? _routeDurationSeconds;
  String? _lastError;
  BitmapDescriptor? _murtiIcon;

  CameraPosition get _initialCameraPosition {
    final latLng = _destinationLatLng ?? const LatLng(19.0760, 72.8777); // Mumbai fallback
    return CameraPosition(target: latLng, zoom: 13);
  }

  LatLng? get _destinationLatLng {
    if (widget.mode == 'aagman') {
      if (widget.pandal.aagmanLat != null && widget.pandal.aagmanLng != null) {
        return LatLng(widget.pandal.aagmanLat!, widget.pandal.aagmanLng!);
      }
    } else {
      if (widget.pandal.visarjanLat != null && widget.pandal.visarjanLng != null) {
        return LatLng(widget.pandal.visarjanLat!, widget.pandal.visarjanLng!);
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _initFlow();
  }

  Future<void> _initFlow() async {
    await _ensureLocationPermission();
    await _loadMurtiMarkerIcon();
    await _loadUserPosition();
    await _loadMurtiLocation();
    _startPolling();
    _updateMarkers();
  }


  Future<void> _loadMurtiMarkerIcon() async {
    try {
      final String assetPath = _assetForPandal(widget.pandal.name);
      final icon = await _bitmapFromAssetCircle(assetPath, 72);
      setState(() => _murtiIcon = icon);
    } catch (_) {}
  }

  String _assetForPandal(String name) {
    final n = name.toLowerCase();
    if (n.contains('lalbaug')) return 'assets/images/lalbaugcha.jpg';
    if (n.contains('gsb')) return 'assets/images/gsb.jpg';
    if (n.contains('chinchpokli') || n.contains('chintamani')) return 'assets/images/chintamani.jpg';
    if (n.contains('mumbaicha')) return 'assets/images/mumbaicha.jpg';
    if (n.contains('fort')) return 'assets/images/fortcha.jpg';
    return 'assets/images/ganpati_placeholder.jpg';
  }

  Future<BitmapDescriptor> _bitmapFromAssetCircle(String path, int size) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: size,
      targetHeight: size,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint()..isAntiAlias = true;
    final double radius = size / 2.0;
    final Rect rect = Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble());

    // Draw circular clip
    final Path pathCircle = Path()..addOval(Rect.fromCircle(center: Offset(radius, radius), radius: radius));
    canvas.clipPath(pathCircle);
    canvas.drawImageRect(
      fi.image,
      Rect.fromLTWH(0, 0, fi.image.width.toDouble(), fi.image.height.toDouble()),
      rect,
      paint,
    );

    final ui.Image roundedImage = await recorder.endRecording().toImage(size, size);
    final ByteData? pngBytes = await roundedImage.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(pngBytes!.buffer.asUint8List());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _ensureLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
  }

  Future<void> _loadUserPosition() async {
    try {
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() => _userPosition = pos);
    } catch (_) {}
  }

  Future<void> _loadMurtiLocation() async {
    final loc = await _repo.fetchCurrentMurtiLocation(
      pandalId: widget.pandal.id,
      mode: widget.mode,
    );
    setState(() {
      _murtiLocation = loc;
      _lastUpdateTime = loc?.updatedAt;
    });
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
      try {
        await _mockStepMurtiTowardsDestination();
        await _loadMurtiLocation();
        _updateMarkers();
        setState(() => _lastError = null);
      } catch (e) {
        setState(() => _lastError = '$e');
      }
    });
  }

  Future<void> _mockStepMurtiTowardsDestination() async {
    // Move murti a small step towards destination each cycle (demo only)
    final dest = _destinationLatLng;
    if (dest == null) return;
    // If we don't have a current position, seed it near user or dest
    LatLng current = _murtiLocation != null
        ? LatLng(_murtiLocation!.latitude, _murtiLocation!.longitude)
        : (_userPosition != null
            ? LatLng(_userPosition!.latitude, _userPosition!.longitude)
            : dest);

    const double stepFraction = 0.05; // 5% towards destination
    final double nextLat = current.latitude + (dest.latitude - current.latitude) * stepFraction;
    final double nextLng = current.longitude + (dest.longitude - current.longitude) * stepFraction;

    try {
      await _repo.upsertMockMurtiLocation(
        pandalId: widget.pandal.id,
        mode: widget.mode,
        latitude: nextLat,
        longitude: nextLng,
        status: 'ongoing',
      );
      setState(() => _lastError = null);
    } catch (e) {
      setState(() => _lastError = 'Upsert failed: $e');
    }
  }

  void _updateMarkers() {
    final Set<Marker> newMarkers = {};
    // User marker
    if (_userPosition != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId('user'),
          position: LatLng(_userPosition!.latitude, _userPosition!.longitude),
          infoWindow: const InfoWindow(title: 'You'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    }
    // Murti marker
    if (_murtiLocation != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId('murti'),
          position: LatLng(_murtiLocation!.latitude, _murtiLocation!.longitude),
          infoWindow: InfoWindow(title: 'Murti (${_murtiLocation!.status})'),
          icon: _murtiIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      );
    }
    // Destination marker
    final dest = _destinationLatLng;
    if (dest != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: dest,
          infoWindow: InfoWindow(title: widget.mode == 'aagman' ? 'Pandal Destination' : 'Visarjan Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
    setState(() => _markers.clear());
    setState(() => _markers.addAll(newMarkers));
    _updateRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.pandal.name} • ${widget.mode[0].toUpperCase()}${widget.mode.substring(1)}'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: _buildStatusBar(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    final String status = _murtiLocation?.status ?? 'not_started';
    final String updated = _lastUpdateTime != null
        ? '${_lastUpdateTime!.toLocal()}'
        : '—';
    // Background now solid white; keep status colors only for icons/text if needed
    final distanceKm = _routeDistanceMeters != null ? (_routeDistanceMeters! / 1000).toStringAsFixed(2) : null;
    final durationMin = _routeDurationSeconds != null ? (_routeDurationSeconds! / 60).round() : null;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Wrap(
        spacing: 12,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 120, maxWidth: 260),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.directions_walk, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(_lastError == null ? 'Status: $status • Updated: $updated' : 'Error: $_lastError', overflow: TextOverflow.ellipsis, maxLines: 1)),
            ]),
          ),
          if (_showRoute && (distanceKm != null && durationMin != null))
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.route, size: 18, color: Theme.of(context).primaryColor),
              const SizedBox(width: 6),
              Text('$distanceKm km • ${durationMin}m')
            ]),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Transform.scale(
              scale: 0.9,
              child: Switch(
                value: _showRoute,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (v) {
                  setState(() => _showRoute = v);
                  _updateRoute();
                },
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () async {
                setState(() => _routeToDestination = !_routeToDestination);
                await _updateRoute();
              },
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(
                  _routeToDestination ? Icons.flag : Icons.person_pin_circle,
                  size: 18,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 4),
                Text(_routeToDestination ? 'Murti→Dest' : 'Murti→You', overflow: TextOverflow.ellipsis),
              ]),
            ),
          ])
        ],
      ),
    );
  }

  Future<void> _updateRoute() async {
    if (!_showRoute) {
      setState(() {
        _polylines.clear();
        _routeDistanceMeters = null;
        _routeDurationSeconds = null;
      });
      return;
    }

    if (_murtiLocation == null) return;
    final origin = LatLng(_murtiLocation!.latitude, _murtiLocation!.longitude);
    LatLng? dest;
    if (_routeToDestination) {
      dest = _destinationLatLng;
    } else {
      if (_userPosition != null) dest = LatLng(_userPosition!.latitude, _userPosition!.longitude);
    }
    if (dest == null) return;

    final route = await _directions.fetchRoute(origin: origin, destination: dest);
    if (route == null) {
      setState(() {
        _polylines.removeWhere((p) => p.polylineId.value == _routePolylineId);
        _routeDistanceMeters = null;
        _routeDurationSeconds = null;
      });
    } else {
      final polyline = Polyline(
        polylineId: const PolylineId(_routePolylineId),
        color: Theme.of(context).primaryColor,
        width: 5,
        points: route.polylinePoints,
      );
      setState(() {
        _polylines.removeWhere((p) => p.polylineId.value == _routePolylineId);
        _polylines.add(polyline);
        _routeDistanceMeters = route.distanceMeters;
        _routeDurationSeconds = route.durationSeconds;
      });
    }

    // Also draw route from Pandal to destination (when applicable)
    await _updatePandalToDestinationRoute();
  }

  Future<void> _updatePandalToDestinationRoute() async {
    final dest = _destinationLatLng;
    if (!_showRoute || dest == null) {
      setState(() {
        _polylines.removeWhere((p) => p.polylineId.value == _pandalRoutePolylineId);
      });
      return;
    }
    // Origins per mode
    LatLng? origin;
    if (widget.mode == 'aagman') {
      // Use current murti location as origin when available
      if (_murtiLocation != null) {
        origin = LatLng(_murtiLocation!.latitude, _murtiLocation!.longitude);
      }
    } else {
      // Visarjan: start at the pandal's aagman destination (pandal location)
      if (widget.pandal.aagmanLat != null && widget.pandal.aagmanLng != null) {
        origin = LatLng(widget.pandal.aagmanLat!, widget.pandal.aagmanLng!);
      }
    }
    if (origin == null) {
      setState(() {
        _polylines.removeWhere((p) => p.polylineId.value == _pandalRoutePolylineId);
      });
      return;
    }

    final route = await _directions.fetchRoute(origin: origin, destination: dest);
    if (route == null || route.polylinePoints.isEmpty) {
      setState(() {
        _polylines.removeWhere((p) => p.polylineId.value == _pandalRoutePolylineId);
      });
      return;
    }
    final polyline = Polyline(
      polylineId: const PolylineId(_pandalRoutePolylineId),
      color: Theme.of(context).primaryColor.withOpacity(0.5),
      width: 4,
      points: route.polylinePoints,
      patterns: [PatternItem.dash(20), PatternItem.gap(10)],
    );
    setState(() {
      _polylines.removeWhere((p) => p.polylineId.value == _pandalRoutePolylineId);
      _polylines.add(polyline);
    });
  }

}
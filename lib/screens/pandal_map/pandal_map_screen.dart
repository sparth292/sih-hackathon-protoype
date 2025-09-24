import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_india_hackathon/screens/pandal_map/ganpati_pandal_info.dart';

class PandalLocation {
  final String name;
  final LatLng position;
  final String markerId;
  final String description;
  final String? imagePath;
  final String? speciality;

  PandalLocation({
    required this.name,
    required double latitude,
    required double longitude,
    this.description = 'Famous Ganesh pandal in Mumbai',
    this.imagePath,
    this.speciality,
  })  : position = LatLng(latitude, longitude),
        markerId = '${latitude}_${longitude}';
}

class PandalMapScreen extends StatefulWidget {
  const PandalMapScreen({Key? key}) : super(key: key);

  @override
  _PandalMapScreenState createState() => _PandalMapScreenState();
}

class _PandalMapScreenState extends State<PandalMapScreen> {
  // Mumbai coordinates
  static const LatLng _mumbaiCenter = LatLng(18.9878, 72.8357); // More centered on the pandals
  static const double _initialZoom = 12.0;
  
  final Set<Marker> _markers = {};
  late GoogleMapController _mapController;
  
  final List<PandalLocation> _pandals = [
    PandalLocation(
      name: 'Chinchpoklicha Chi..', 
      latitude: 18.98806, 
      longitude: 72.83306,
      description: 'One of the oldest and most revered Ganesh pandals in Mumbai, known for its serene atmosphere.',
      speciality: 'Eco-friendly idol and traditional celebrations',
    ),
    PandalLocation(
      name: 'GSB Seva Mandal', 
      latitude: 19.02931, 
      longitude: 72.85832,
      description: 'Famous for its grand celebrations and cultural programs during Ganesh Chaturthi.',
      speciality: 'Grand processions and cultural events',
    ),
    PandalLocation(
      name: 'Kalachowkicha Maha..', 
      latitude: 18.98808, 
      longitude: 72.83730,
      description: 'A historic pandal known for its traditional celebrations and community involvement.',
      speciality: 'Traditional aartis and community feasts',
    ),
    PandalLocation(
      name: 'Keshavji Naik Chawl..', 
      latitude: 18.95467, 
      longitude: 72.82198,
      description: 'A century-old celebration in a traditional Mumbai chawl, known for its homely atmosphere.',
      speciality: 'Authentic chawl celebrations',
    ),
    PandalLocation(
      name: 'Lalbaugcha Raja', 
      latitude: 18.99120, 
      longitude: 72.83670,
      description: 'The most famous Ganesh pandal in Mumbai, attracting millions of devotees. Known for fulfilling wishes.',
      speciality: 'Navas (wish fulfillment)',
    ),
    PandalLocation(
      name: 'Mumbaicha Raja', 
      latitude: 18.99433, 
      longitude: 72.83746,
      description: 'Known for its eco-friendly celebrations and innovative themes each year.',
      speciality: 'Eco-friendly celebrations',
    ),
    PandalLocation(
      name: 'Parelcha Maharaja', 
      latitude: 19.00508, 
      longitude: 72.83786,
      description: 'One of the oldest mandals in Mumbai, known for its traditional celebrations.',
      speciality: 'Traditional aartis and cultural programs',
    ),
    PandalLocation(
      name: 'Umarkhadicha Raja', 
      latitude: 18.96178, 
      longitude: 72.83587,
      description: 'Famous for its grand decorations and cultural programs during the festival.',
      speciality: 'Grand decorations',
    ),
    PandalLocation(
      name: 'Fortcha Raja', 
      latitude: 18.93768, 
      longitude: 72.83613,
      description: 'Located in South Mumbai, known for its elegant celebrations and traditional rituals.',
      speciality: 'Traditional rituals',
    ),
    PandalLocation(
      name: 'Girgaoncha Raja', 
      latitude: 18.95499, 
      longitude: 72.82038,
      description: 'The "King of Girgaon," established in 1928, known for its eco-friendly clay idol and community initiatives.',
      speciality: 'Eco-friendly and community-driven',
    ),
    PandalLocation(
      name: 'Tardeocha Raja', 
      latitude: 18.97139, 
      longitude: 72.81776,
      description: 'Famous for its creative themes and eco-friendly celebrations.',
      speciality: 'Creative themes and eco-friendly initiatives',
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    _addMarkers();
  }
  
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }
  
  void _addMarkers() {
    setState(() {
      _markers.clear();
      for (var pandal in _pandals) {
        _markers.add(
          Marker(
            markerId: MarkerId(pandal.markerId),
            position: pandal.position,
            infoWindow: InfoWindow(
              title: pandal.name,
              snippet: pandal.speciality,
              onTap: () {
                _showPandalDetails(context, pandal);
              },
            ),
            onTap: () {
              _showPandalDetails(context, pandal);
            },
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          ),
        );
      }
    });
  }

  void _showPandalDetails(BuildContext context, PandalLocation pandal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pandal.name,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF333333),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Speciality chip
            if (pandal.speciality != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '✨ ${pandal.speciality!}',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFFF9B00),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Description
            Text(
              pandal.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            // Directions button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GanpatiPandalInfo(
                        ganpatiName: pandal.name,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9B00),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Get Info',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Pandal Map',
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFD2691E),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _mumbaiCenter,
              zoom: _initialZoom,
            ),
            markers: _markers,
            minMaxZoomPreference: const MinMaxZoomPreference(10, 18),
            // Restrict map bounds to Mumbai area
            cameraTargetBounds: CameraTargetBounds(
              LatLngBounds(
                northeast: const LatLng(19.2870, 72.9862), // North-East boundary of Mumbai
                southwest: const LatLng(18.9064, 72.7759), // South-West boundary of Mumbai
              ),
            ),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            onTap: (LatLng position) {
              // Close any open info windows when tapping on the map
              _mapController.hideMarkerInfoWindow(const MarkerId(''));
            },
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: FloatingActionButton(
              onPressed: () {
                _mapController.animateCamera(
                  CameraUpdate.newLatLngZoom(_mumbaiCenter, _initialZoom),
                );
              },
              backgroundColor: const Color(0xFFFF9B00),
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

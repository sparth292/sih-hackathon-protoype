import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_india_hackathon/ganpati_details/ganpati_info.dart';

class GanpatiPandalInfo extends StatelessWidget {
  final String ganpatiName;
  
  const GanpatiPandalInfo({
    Key? key,
    required this.ganpatiName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final details = getGanpatiDetails(ganpatiName);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ganpatiName,
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFD2691E)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            if (details?['image'] != null)
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(details!['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Speciality chip
            if (details?['speciality'] != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '✨ ${details!['speciality']}',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFFF9B00),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Description
            Text(
              'About',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              details?['description'] ?? 'No description available',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[800],
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Additional Info Section
            _buildInfoSection(
              context,
              title: 'Visiting Hours',
              content: '5:00 AM - 10:00 PM',
              icon: Icons.access_time,
            ),
            
            _buildInfoSection(
              context,
              title: 'Best Time to Visit',
              content: 'Morning or Evening Aarti',
              icon: Icons.calendar_today,
            ),
            
            const SizedBox(height: 32),
            
            // Map Preview
            Text(
              'Location',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!), 
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(18.9878, 72.8357), // Default to Mumbai center
                    zoom: 12,
                  ),
                  markers: {
                    if (details?['position'] != null)
                      Marker(
                        markerId: const MarkerId('pandal_location'),
                        position: details!['position'],
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueOrange,
                        ),
                      ),
                  },
                  scrollGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  myLocationButtonEnabled: false,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Get Directions Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement directions
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening directions...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9B00),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.directions, color: Colors.white),
                label: Text(
                  'Get Directions',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoSection(BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFFF9B00), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

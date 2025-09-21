import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import 'festival_map_screen.dart';

class FestivalDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> festivalDetails;

  const FestivalDetailsScreen({
    Key? key,
    required this.festivalDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                festivalDetails['name'],
                style: GoogleFonts.playfairDisplay(
                  color: AppTheme.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 2),
                      blurRadius: 4.0,
                      color: AppTheme.textPrimary.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
              background: Hero(
                tag: 'festival-${festivalDetails['name']}',
                child: Image.asset(
                  festivalDetails['image'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.textPrimary.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppTheme.white,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppTheme.secondaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        festivalDetails['location'],
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, color: AppTheme.accentColor, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '4.8 (1.2K)',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'About',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    festivalDetails['description'],
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      height: 1.6,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Timings',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTimingCard(
                    'Morning Aarti',
                    '5:30 AM - 6:30 AM',
                    Icons.wb_sunny_outlined,
                  ),
                  _buildTimingCard(
                    'Afternoon Aarti',
                    '12:30 PM - 1:30 PM',
                    Icons.light_mode_outlined,
                  ),
                  _buildTimingCard(
                    'Evening Aarti',
                    '7:30 PM - 8:30 PM',
                    Icons.nights_stay_outlined,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FestivalMapScreen(
                              festival: festivalDetails,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.map_outlined, color: Colors.white),
                      label: Text(
                        'View on Map',
                        style: GoogleFonts.roboto(
                          color: AppTheme.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimingCard(String title, String time, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: AppTheme.accentColor),
        title: Text(
          title,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Text(
          time,
          style: GoogleFonts.roboto(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

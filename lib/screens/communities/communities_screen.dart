import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';
import '../festivals/festivals_screen.dart';
import '../store/store_screen.dart';

class CommunitiesScreen extends StatelessWidget {
  const CommunitiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Communities',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF333333),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: const Color(0xFFFF9B00),
            ),
            const SizedBox(height: 20),
            Text(
              'Communities Coming Soon',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Connect with festival communities',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 3, // Communities tab is selected
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFF9B00),
        unselectedItemColor: const Color(0xFF666666),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 24),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.location_on, size: 24),
            label: 'Pandals',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.store, size: 24),
            label: 'Store',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people_outline, size: 24),
            label: 'Communities',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const FestivalsScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const StoreScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/login_screen.dart'; // Make sure this path is correct for your project

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  final PageController _pageController = PageController();

  // Data for the onboarding pages
  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboarding.png', // Replace with your image path
      'title': 'Know your culture',
      'subtitle': 'Dive into a world of vibrant cultures.',
    },
    {
      'image': 'assets/images/onboarding.png', // Replace with your image path
      'title': 'Track Pandals',
      'subtitle': 'Real-time locations and updates for all festival pandals near you.',
    },
    {
      'image': 'assets/images/onboarding.png', // Replace with your image path
      'title': 'Book musical groups',
      'subtitle': 'Skip the lines and book musical groups.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F5),
      body: SafeArea(
        child: Column( // Changed back to Column as SingleChildScrollView with fixed height isn't ideal
          children: [
            // Skip button (top right)
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Skip',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF666666),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Main content - Using Expanded to take available space
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(
                    imagePath: onboardingData[index]['image']!,
                    title: onboardingData[index]['title']!,
                    subtitle: onboardingData[index]['subtitle']!,
                  );
                },
              ),
            ),

            // Progress dots
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(onboardingData.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == currentPage
                          ? const Color(0xFFFF9B00)
                          : const Color(0xFFFFE0B2),
                    ),
                  );
                }),
              ),
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 30.0), // Increased bottom padding for the button
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (currentPage < onboardingData.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9B00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    currentPage < onboardingData.length - 1 ? 'Next' : 'Get Started',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage({required String imagePath, required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Align content to the start
        children: [
          // Reduced top padding for the image to bring it closer to 'Skip'
          const SizedBox(height: 20), // Reduced from 50 to 20 or even 0 depending on desired closeness

          // Image with border radius
          ClipRRect( // Added ClipRRect for border radius
            borderRadius: BorderRadius.circular(16.0), // Adjust radius as desired
            child: Image.asset(
              imagePath,
              height: 250,
              fit: BoxFit.cover, // Changed to cover for better image display within bounds
            ),
          ),

          const SizedBox(height: 40), // Space between image and title (can be adjusted)

          // Title
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Subtitle
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(0xFF666666),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
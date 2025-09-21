import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_india_hackathon/screens/home/home_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Color scheme to match homepage and login
    const Color primaryColor = Color(0xFF8B4513); // Brown
    const Color backgroundColor = Color(0xFFF5F5DC); // Beige
    const Color cardBackground = Color(0xFFFFF8E7); // Light beige
    const Color textColor = Color(0xFF5D4037); // Dark brown
    const Color textSecondary = Color(0xFF8D6E63); // Light brown
    const Color white = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        
        child: Stack(
          
          children: [
            // Background
            Positioned.fill(
              child: Container(
                color: backgroundColor,
              ),
            ),
            
            // Back button (top left)
            
            // Main Card
            Center(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(30),
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'Create Account',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          height: 1.2,
                        ),
                      ),
                      
                      // Subtitle
                      Text(
                        'Join our community today',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16,
                          color: textColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Name Field
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: white,
                          hintText: 'Full Name',
                          hintStyle: TextStyle(color: textSecondary),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: textSecondary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Email Field
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: white,
                          hintText: 'Email',
                          hintStyle: TextStyle(color: textSecondary),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: textSecondary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Password Field
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: white,
                          hintText: 'Password',
                          hintStyle: TextStyle(color: textSecondary),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: textSecondary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Confirm Password Field
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: white,
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(color: textSecondary),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: textSecondary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 25),
                      
                      // Login Prompt
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: GoogleFonts.playfairDisplay(
                              color: textColor.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Login',
                              style: GoogleFonts.playfairDisplay(
                                color: primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // Terms and Conditions
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'By signing up, you agree to our Terms of Service and Privacy Policy',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            color: textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

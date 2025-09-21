import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F5),
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF333333),
                    size: 20,
                  ),
                ),
              ),
            ),
            
            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(30),
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Subtitle
                        Text(
                          'Join our community today',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: const Color(0xFF666666),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Full Name Field
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF8F8F8),
                            hintText: 'Full Name',
                            hintStyle: const TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.person_outline,
                              color: Color(0xFF666666),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
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
                            fillColor: const Color(0xFFF8F8F8),
                            hintText: 'Email',
                            hintStyle: const TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Color(0xFF666666),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
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
                            fillColor: const Color(0xFFF8F8F8),
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Color(0xFF666666),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
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
                            fillColor: const Color(0xFFF8F8F8),
                            hintText: 'Confirm Password',
                            hintStyle: const TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Color(0xFF666666),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
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
                              backgroundColor: const Color(0xFFFF9B00),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Login Prompt
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF666666),
                                fontSize: 14,
                              ),
                              children: [
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Login',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFFFF9B00),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Terms and Conditions
                        Center(
                          child: Text(
                            'By signing up, you agree to our Terms of Service and Privacy Policy',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF999999),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
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
}

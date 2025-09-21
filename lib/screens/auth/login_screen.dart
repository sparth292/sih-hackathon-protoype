import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(30),
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
                        'Welcome Back',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Subtitle
                      Text(
                        'Sign in to continue your festival journey',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: const Color(0xFF666666),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Email Field
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF8F8F8),
                          hintText: 'Email or username',
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
                      
                      const SizedBox(height: 16),
                      
                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot password?',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFFF9B00),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
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
                            'Log In',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Sign Up Prompt
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF666666),
                              fontSize: 14,
                            ),
                            children: [
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SignupScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Sign Up',
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

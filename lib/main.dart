import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Google Fonts
  GoogleFonts.config.allowRuntimeFetching = true;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Updated color scheme
    const Color primaryColor = Color(0xFFFF9B00); // Orange
    const Color backgroundColor = Color(0xFFF8F7F5); // Updated background
    const Color textColor = Color(0xFF333333); // Dark grey text

    return MaterialApp(
      title: 'Utsava',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Use Poppins as the default font
        fontFamily: 'Poppins',
        // Color scheme
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        // Text theme
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        // App bar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor),
          titleTextStyle: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          hintStyle: const TextStyle(
            color: Color(0xFF999999),
          ),
        ),
        // Elevated button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Text button theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF32D97E);
  static const Color secondary = Color(0xFF242F3E);
  static const Color greyText = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0); 
  static const Color white = Colors.white;
  static const Color screen = Color(0xFFF8FAFC); 


  static TextStyle headingStyle = GoogleFonts.inter(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    color: secondary,
  );

  static TextStyle bodyStyle = GoogleFonts.inter(
    fontWeight: FontWeight.normal,
    fontSize: 14.4,
    color: greyText,
  );

  static TextStyle labelStyle = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 14.4,
    color: secondary,
  );

  static TextStyle buttonStyle = GoogleFonts.inter(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: white,
  );

  static TextStyle linkStyle = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: primary,
  );

  static InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 16),
      filled: true,
      fillColor: white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 1.6),
      ),
    );
  }

  static BoxDecoration buttonDecorationPrimary = BoxDecoration(
    color: primary,
    borderRadius: BorderRadius.circular(12),
  );

  static ThemeData get lightTheme {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: screen,
    colorScheme: ColorScheme.fromSeed(seedColor: primary),
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.light().textTheme,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 18,
        ),
      ),
    ),
  );
}
  static BoxDecoration inputContainerDecoration = BoxDecoration(
    color: white, 
    borderRadius: BorderRadius.circular(12), 
    border: Border.all(
      color: border,
      width: 1.0,
    ),
  );
}
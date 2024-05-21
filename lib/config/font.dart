import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class Fonts {
  Fonts._();

  static final TextStyle largeTitle = GoogleFonts.neuton(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.6,
    color: Colors.white
  );

  static final TextStyle title = GoogleFonts.notoSansKr(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.6,
    color: Colors.white
  );

  static final TextStyle subtitle = GoogleFonts.notoSansKr(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 1
  );

  static final TextStyle subtitle2 = GoogleFonts.notoSansKr(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 1
  );

  static final TextStyle parag1 = GoogleFonts.notoSansKr(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
  );
  static final TextStyle parag1_w = GoogleFonts.notoSansKr(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
    color: Colors.white
  );

  static final TextStyle parag2 = GoogleFonts.notoSansKr(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 1
  );

  static final TextStyle parag3 = GoogleFonts.notoSansKr(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 1
  );

  static final TextStyle parag4 = GoogleFonts.notoSansKr(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 1
  );

  static final TextStyle label = GoogleFonts.notoSansKr(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 1
  );
}
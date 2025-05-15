import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTs extends StatelessWidget {
  final String? text;
  final Color? color;
  final double? fontSize;
  const CustomTs({super.key, this.text, this.color, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: GoogleFonts.poppins(
        fontSize: fontSize ?? 20,
        fontWeight: FontWeight.bold,
        color: color ?? Colors.white,
      ),
    );
  }
}

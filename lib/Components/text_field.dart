import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget textField(
    {required label, obscureText = false, required IconData icon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const SizedBox(
        height: 5,
      ),
      Text(
        label,
        style: GoogleFonts.montserrat(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
      ),
      const SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.black87,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black87),
            ),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87))),
      ),
    ],
  );
}

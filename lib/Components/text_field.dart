import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget textField({
  required String label,
  bool obscureText = false,
  required IconData icon,
  TextEditingController? controller,
  String? hintText,
  TextInputType? keyboardType,
  ValueChanged<String>? onChanged,
  bool readOnly = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const SizedBox(height: 5),
      if (label.isNotEmpty) ...[
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
      ],
      TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hintText,
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
            borderSide: BorderSide(color: Colors.black87),
          ),
        ),
      ),
    ],
  );
}

Widget inputFile({
  required String label,
  String? teks,
  bool obscureText = false,
  required IconData icon,
  TextEditingController? controller,
  TextInputType? keyboardType,
  ValueChanged<String>? onChanged,
  bool readOnly = false,
  bool filled = false,
  Color? fillColor,
  Color labelColor = Colors.black,
  Color iconColor = const Color.fromARGB(255, 255, 203, 59),
  VoidCallback? onPrefixTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      if (label.isNotEmpty) ...[
        const SizedBox(height: 15),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 5),
      ],
      TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: teks,
          filled: filled,
          fillColor: fillColor ?? const Color.fromRGBO(255, 252, 225, 1),
          prefixIcon: onPrefixTap != null
              ? IconButton(
                  icon: Icon(icon, color: iconColor),
                  onPressed: onPrefixTap,
                )
              : Icon(icon, color: iconColor),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 255, 203, 59),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
          ),
        ),
      ),
    ],
  );
}

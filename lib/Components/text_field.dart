import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/theme/app_theme.dart';

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
      const SizedBox(height: 6),
      if (label.isNotEmpty) ...[
        Text(
          label.toUpperCase(),
          style: GoogleFonts.robotoMono(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.inkMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
      ],
      TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        readOnly: readOnly,
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.montserrat(
            fontSize: 13,
            color: AppColors.inkLight,
          ),
          prefixIcon: Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.border, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.border, width: 1),
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
  Color labelColor = AppColors.ink,
  Color iconColor = AppColors.primary,
  VoidCallback? onPrefixTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      if (label.isNotEmpty) ...[
        const SizedBox(height: 12),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.robotoMono(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: labelColor == Colors.black ? AppColors.inkMuted : labelColor,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
      ],
      TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        readOnly: readOnly,
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        decoration: InputDecoration(
          hintText: teks,
          hintStyle: GoogleFonts.montserrat(
            fontSize: 13,
            color: AppColors.inkLight,
          ),
          filled: filled || fillColor != null,
          fillColor: fillColor ?? AppColors.surface,
          prefixIcon: onPrefixTap != null
              ? IconButton(
                  icon: Icon(icon, size: 18, color: iconColor),
                  onPressed: onPrefixTap,
                )
              : Icon(icon, size: 18, color: iconColor),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.border, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.border, width: 1),
          ),
        ),
      ),
    ],
  );
}

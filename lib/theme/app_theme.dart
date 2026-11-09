import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens and semantic colors for the RouteWise "Industrial Dispatch & Manifest Ledger" system.
class AppColors {
  AppColors._();

  // Core Brand
  static const Color primary = Color(0xFFE45F2B); // Brand Terracotta
  static const Color primaryDark = Color(0xFFB84318);
  static const Color primaryLight = Color(0xFFFFF1EB);
  static const Color amberStamp = Color(0xFFF6C445); // Brand Amber / Gold
  static const Color amberText = Color(0xFF9A3412); // High-contrast amber (6.7:1 vs white)

  // Canvas & Surfaces (Warm Manila / Ledger Paper)
  static const Color canvas = Color(0xFFF7F4EC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF2EDE2);
  static const Color border = Color(0xFFDCD5C7);
  static const Color borderDark = Color(0xFF9E978C);

  // Typography Inks
  static const Color ink = Color(0xFF1E1815); // Warm Espresso
  static const Color inkMuted = Color(0xFF655E54); // Muted Ledger Label
  static const Color inkLight = Color(0xFF8F887C);

  // Semantic Status (Verified Green, In-Transit Amber, Rejected Red)
  static const Color statusGreenText = Color(0xFF14532D);
  static const Color statusGreenBg = Color(0xFFDCFCE7);
  static const Color statusGreenBorder = Color(0xFF86EFAC);
  static const Color statusGreenAction = Color(0xFF15803D);

  static const Color statusAmberText = Color(0xFF92400E);
  static const Color statusAmberBg = Color(0xFFFEF3C7);
  static const Color statusAmberBorder = Color(0xFFFDE68A);

  static const Color statusRedText = Color(0xFF991B1B);
  static const Color statusRedBg = Color(0xFFFEE2E2);
  static const Color statusRedBorder = Color(0xFFFECACA);
}

/// Helper methods and typography styles for the application.
class AppTheme {
  AppTheme._();

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 768;
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.canvas,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.amberStamp,
        surface: AppColors.surface,
        background: AppColors.canvas,
        onPrimary: Colors.white,
        onSecondary: AppColors.ink,
        onSurface: AppColors.ink,
        onBackground: AppColors.ink,
      ),
      textTheme: GoogleFonts.montserratTextTheme().apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}

/// Custom perforated dashed separator line reminiscent of a physical waybill/manifest slip.
class DashedRule extends StatelessWidget {
  final double height;
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const DashedRule({
    super.key,
    this.height = 1,
    this.color = AppColors.border,
    this.dashWidth = 5,
    this.dashSpace = 4,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return SizedBox(
          width: boxWidth,
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: height,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

/// Semantic stamp badge with 1px border and uppercase tracking label.
class StatusStampBadge extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final IconData? icon;

  const StatusStampBadge({
    super.key,
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    this.icon,
  });

  factory StatusStampBadge.pending({String label = 'MENUNGGU'}) {
    return StatusStampBadge(
      label: label,
      textColor: AppColors.statusAmberText,
      backgroundColor: AppColors.statusAmberBg,
      borderColor: AppColors.statusAmberBorder,
      icon: Icons.access_time_rounded,
    );
  }

  factory StatusStampBadge.approved({String label = 'DISETUJUI'}) {
    return StatusStampBadge(
      label: label,
      textColor: AppColors.statusGreenText,
      backgroundColor: AppColors.statusGreenBg,
      borderColor: AppColors.statusGreenBorder,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  factory StatusStampBadge.rejected({String label = 'DITOLAK'}) {
    return StatusStampBadge(
      label: label,
      textColor: AppColors.statusRedText,
      backgroundColor: AppColors.statusRedBg,
      borderColor: AppColors.statusRedBorder,
      icon: Icons.cancel_outlined,
    );
  }

  factory StatusStampBadge.inTransit({String label = 'DALAM PENGIRIMAN'}) {
    return StatusStampBadge(
      label: label,
      textColor: AppColors.statusAmberText,
      backgroundColor: AppColors.statusAmberBg,
      borderColor: AppColors.statusAmberBorder,
      icon: Icons.local_shipping_outlined,
    );
  }

  factory StatusStampBadge.delivered({String label = 'SELESAI'}) {
    return StatusStampBadge(
      label: label,
      textColor: AppColors.statusGreenText,
      backgroundColor: AppColors.statusGreenBg,
      borderColor: AppColors.statusGreenBorder,
      icon: Icons.verified_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.override(
          top: BorderSide(color: borderColor, width: 1),
          bottom: BorderSide(color: borderColor, width: 1),
          left: BorderSide(color: borderColor, width: 1),
          right: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: GoogleFonts.robotoMono(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

/// A structured cell for ledger metadata (uppercase label + tabular numeric value).
class LedgerDataCell extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final CrossAxisAlignment crossAxisAlignment;

  const LedgerDataCell({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.robotoMono(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.inkMuted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        RichText(
          text: TextSpan(
            text: value,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            children: [
              if (unit != null)
                TextSpan(
                  text: ' $unit',
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.inkMuted,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

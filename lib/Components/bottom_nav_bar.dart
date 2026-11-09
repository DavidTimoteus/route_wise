import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/models/route_models.dart';
import 'package:route_wise/pages/DashboardKepalaGudang.dart';
import 'package:route_wise/pages/ListPermintaan.dart';
import 'package:route_wise/pages/PengelolaanSPK.dart';
import 'package:route_wise/pages/PengirimanBarang.dart';
import 'package:route_wise/pages/Profil.dart';
import 'package:route_wise/pages/RekomendasiRute.dart';
import 'package:route_wise/pages/WelcomeScreen.dart';
import 'package:route_wise/services/app_state.dart';
import 'package:route_wise/theme/app_theme.dart';

class MyBottomNavBar extends StatefulWidget {
  final int? initialIndex;

  const MyBottomNavBar({super.key, this.initialIndex});

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int myCurrentIndex = 0;
  bool _initializedFromRole = false;

  final List<Widget> pages = const [
    DashboardKepalaGudang(),
    ListPermintaan(),
    PengirimanBarang(),
    RekomendasiRute(),
    PengelolaanSPK(),
  ];

  static const List<_NavItem> _navItems = [
    _NavItem(
      icon: FontAwesomeIcons.chartLine,
      label: 'Dashboard',
      code: 'MON-01',
    ),
    _NavItem(
      icon: FontAwesomeIcons.fileLines,
      label: 'Permintaan',
      code: 'REQ-02',
    ),
    _NavItem(
      icon: FontAwesomeIcons.truckFast,
      label: 'Pengiriman',
      code: 'DSP-03',
    ),
    _NavItem(
      icon: FontAwesomeIcons.mapLocationDot,
      label: 'Rute GPS',
      code: 'MAP-04',
    ),
    _NavItem(
      icon: FontAwesomeIcons.sliders,
      label: 'SPK SAW',
      code: 'SPK-05',
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedFromRole) {
      _initializedFromRole = true;
      if (widget.initialIndex != null) {
        myCurrentIndex = widget.initialIndex!;
      } else {
        final role = AppStateScope.of(context).currentUser.role;
        if (role == UserRole.driver) {
          myCurrentIndex = 3;
        } else if (role == UserRole.admin) {
          myCurrentIndex = 4;
        } else {
          myCurrentIndex = 0;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppTheme.isDesktop(context);
    final user = AppStateScope.of(context).currentUser;

    if (isDesktop) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: Row(
          children: [
            // Responsive Sidebar Manifest
            Container(
              width: 250,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  right: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Brand Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceMuted,
                      border: Border(
                        bottom: BorderSide(color: AppColors.border, width: 1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                FontAwesomeIcons.route,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'RouteWise',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.ink,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                Text(
                                  'LOGISTICS LEDGER',
                                  style: GoogleFonts.robotoMono(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Active Personnel Card
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage(user.avatarAsset),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.fullName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    Text(
                                      user.roleLabel.toUpperCase(),
                                      style: GoogleFonts.robotoMono(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.amberText,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Navigation Items
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: _navItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                      itemBuilder: (context, index) {
                        final item = _navItems[index];
                        final isSelected = myCurrentIndex == index;

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 2,
                            ),
                            leading: Icon(
                              item.icon,
                              size: 16,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.inkMuted,
                            ),
                            title: Text(
                              item.label,
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.ink,
                              ),
                            ),
                            trailing: Text(
                              item.code,
                              style: GoogleFonts.robotoMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white.withOpacity(0.8)
                                    : AppColors.inkLight,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                myCurrentIndex = index;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom Utilities
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.border, width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.ink,
                              side: const BorderSide(color: AppColors.border),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            icon: const Icon(Icons.person_outline, size: 16),
                            label: Text(
                              'Profil',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Profil(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: 'Logout',
                          icon: const Icon(
                            Icons.logout_rounded,
                            size: 18,
                            color: AppColors.statusRedText,
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WelcomeScreen(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: ClipRect(
                child: pages[myCurrentIndex],
              ),
            ),
          ],
        ),
      );
    }

    // Mobile Navigation Shell
    return Scaffold(
      body: pages[myCurrentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.surface,
              elevation: 0,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.inkMuted,
              selectedLabelStyle: GoogleFonts.montserrat(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: GoogleFonts.montserrat(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              currentIndex: myCurrentIndex,
              onTap: (index) {
                setState(() {
                  myCurrentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.chartLine, size: 18),
                  activeIcon: Icon(FontAwesomeIcons.chartLine, size: 19),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.fileLines, size: 18),
                  activeIcon: Icon(FontAwesomeIcons.fileLines, size: 19),
                  label: 'Permintaan',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.truckFast, size: 18),
                  activeIcon: Icon(FontAwesomeIcons.truckFast, size: 19),
                  label: 'Pengiriman',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.mapLocationDot, size: 18),
                  activeIcon: Icon(FontAwesomeIcons.mapLocationDot, size: 19),
                  label: 'Rute',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.sliders, size: 18),
                  activeIcon: Icon(FontAwesomeIcons.sliders, size: 19),
                  label: 'SPK',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String code;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.code,
  });
}

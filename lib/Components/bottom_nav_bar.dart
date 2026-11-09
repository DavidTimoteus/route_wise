import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:route_wise/models/route_models.dart';
import 'package:route_wise/pages/DashboardKepalaGudang.dart';
import 'package:route_wise/pages/ListPermintaan.dart';
import 'package:route_wise/pages/PengelolaanSPK.dart';
import 'package:route_wise/pages/PengirimanBarang.dart';
import 'package:route_wise/pages/RekomendasiRute.dart';
import 'package:route_wise/services/app_state.dart';

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
    return Scaffold(
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF6C445).withOpacity(0.5),
              blurRadius: 25,
              offset: const Offset(1, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFFE45F2B),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black87,
            currentIndex: myCurrentIndex,
            onTap: (index) {
              setState(() {
                myCurrentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.house),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.chartColumn),
                label: 'Request',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.truck),
                label: 'Shipping',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.mapLocationDot),
                label: 'Route',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.sliders),
                label: 'SPK',
              ),
            ],
          ),
        ),
      ),
      body: pages[myCurrentIndex],
    );
  }
}

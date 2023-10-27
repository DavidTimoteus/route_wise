import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:route_wise/Pages/DashboardKepalaGudang.dart';
import 'package:route_wise/Pages/ListPermintaan.dart';
import 'package:route_wise/Pages/PengirimanBarang.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({super.key});

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBar();
}

class _MyBottomNavBar extends State<MyBottomNavBar> {
  int myCurrentIndex = 0;
  List pages = [
    DashboardKepalaGudang(),
    ListPermintaan(),
    PengirimanBarang(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Color(0xFFF6C445).withOpacity(0.5),
              blurRadius: 25,
              offset: Offset(1, 5))
        ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BottomNavigationBar(
              backgroundColor: Color(0xFFE45F2B),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.black87,
              currentIndex: myCurrentIndex,
              onTap: (index) {
                setState(() {
                  myCurrentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.house), label: 'Dashboard'),
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.chartColumn), label: 'Request'),
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.truck), label: 'Shipping'),
              ]),
        ),
      ),
      body: pages[myCurrentIndex],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:route_wise/Components/bottom_nav_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyBottomNavBar(),
    );
  }
}

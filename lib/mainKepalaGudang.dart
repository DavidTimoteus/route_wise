import 'package:flutter/material.dart';
import 'package:route_wise/Pages/DashboardKepalaGudang.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardKepalaGudang(),
    );
  }
}

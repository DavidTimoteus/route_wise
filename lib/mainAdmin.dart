import 'package:flutter/material.dart';
import 'package:route_wise/Pages/PengelolaanSPK.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PengelolaanSPK(),
    );
  }
}

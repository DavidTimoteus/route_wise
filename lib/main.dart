import 'package:flutter/material.dart';
import 'pages/WelcomeScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/LoginPage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/KelolaProfil.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
@override
Widget build(BuildContext context){
  return MaterialApp(
    theme: ThemeData(
      textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
    ),
    debugShowCheckedModeBanner: false,
    home: KelolaProfil()
  );
}
}
 


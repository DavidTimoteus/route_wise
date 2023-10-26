import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/profil_kpl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/profil_kpl.dart';

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
    home: profil_kpl()
  );
}
}
 


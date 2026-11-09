import 'package:flutter/material.dart';
import 'package:route_wise/Components/bottom_nav_bar.dart';
import 'package:route_wise/pages/KelolaProfil.dart';
import 'package:route_wise/pages/ListPermintaan.dart';
import 'package:route_wise/pages/Login.dart';
import 'package:route_wise/pages/PengelolaanSPK.dart';
import 'package:route_wise/pages/PengirimanBarang.dart';
import 'package:route_wise/pages/Profil.dart';
import 'package:route_wise/pages/RekomendasiRute.dart';
import 'package:route_wise/pages/SignUp.dart';
import 'package:route_wise/pages/WelcomeScreen.dart';
import 'package:route_wise/services/app_state.dart';
import 'package:route_wise/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppState _appState = AppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: _appState,
      child: MaterialApp(
        title: 'RouteWise',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const WelcomeScreen(),
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => const Login(),
          '/signup': (context) => const SignUp(),
          '/home': (context) => const MyBottomNavBar(),
          '/profil': (context) => const Profil(),
          '/kelola-profil': (context) => const KelolaProfil(),
          '/list-permintaan': (context) => const ListPermintaan(),
          '/pengiriman': (context) => const PengirimanBarang(),
          '/rekomendasi-rute': (context) => const RekomendasiRute(),
          '/spk': (context) => const PengelolaanSPK(),
        },
      ),
    );
  }
}

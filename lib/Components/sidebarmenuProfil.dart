import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/pages/KelolaProfil.dart';
import 'package:route_wise/pages/Profil.dart';
import 'package:route_wise/pages/WelcomeScreen.dart';
import 'package:route_wise/services/app_state.dart';

class ProfilKepalaGudang extends StatelessWidget {
  const ProfilKepalaGudang({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: MyDrawer(),
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    final user = AppStateScope.of(context).currentUser;

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            accountName: Text(
              user.fullName,
              style: GoogleFonts.montserrat(
                color: const Color(0xFFE45F2B),
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            accountEmail: Text(
              user.email,
              style: GoogleFonts.montserrat(
                color: const Color(0xFFE45F2B),
                fontWeight: FontWeight.w400,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.asset(user.avatarAsset)),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 4,
            padding: const EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/images/DB Route.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle, color: Color(0xFFE45F2B)),
            title: const Text(
              'Profil',
              style: TextStyle(color: Color(0xFFE45F2B)),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profil()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xFFE45F2B)),
            title: const Text(
              'Kelola Profil',
              style: TextStyle(color: Color(0xFFE45F2B)),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KelolaProfil()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Color(0xFFE45F2B)),
            title: const Text(
              'Bantuan',
              style: TextStyle(color: Color(0xFFE45F2B)),
            ),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'RouteWise v1.0 - Sistem Rekomendasi Rute & Pengiriman',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFE45F2B)),
            title: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFFE45F2B)),
            ),
            onTap: () {
              Navigator.pop(context);
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
    );
  }
}

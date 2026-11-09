import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilKepalaGudang extends StatelessWidget {
  const ProfilKepalaGudang({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            accountName: Text("Ilham Maulana Ahmad",
                style: GoogleFonts.montserrat(
                    color: const Color(0xFFE45F2B),
                    fontWeight: FontWeight.w700,
                    fontSize: 20)),
            accountEmail: Text("IlhamMaulana@gmail.com",
                style: GoogleFonts.montserrat(
                    color: const Color(0xFFE45F2B), fontWeight: FontWeight.w400)),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.asset('assets/images/Profile.jpg')),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 4,
            padding: const EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                "assets/images/DB Route.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(
              'Profil',
              style: TextStyle(color: Color(0xFFE45F2B)),
            ),
            onTap: () {
              Navigator.pop(context);
              setState(() {
// Set `isProfilSelected` ke `true` saat Profil dipilih
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(
              'Help',
              style: TextStyle(color: Color(0xFFE45F2B)),
            ),
            onTap: () {
              Navigator.pop(context);
              setState(() {
// Set `isProfilSelected` ke `true` saat Profil dipilih
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(
              'Help',
              style: TextStyle(color: Color(0xFFE45F2B)),
            ),
            onTap: () {
              Navigator.pop(context);
              setState(() {
// Set `isProfilSelected` ke `true` saat Profil dipilih
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(
              'Help',
              style: TextStyle(color: Color(0xFFE45F2B)),
            ),
            onTap: () {
              Navigator.pop(context);
              setState(() {
// Set `isProfilSelected` ke `true` saat Profil dipilih
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: TextStyle(color: Color(0xFFE45F2B)),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
              style: TextStyle(color: Color(0xFFE45F2B)),
            ),
            onTap: () {
              // Tindakan yang diambil saat keluar dipilih
              Navigator.pop(context); // Tutup drawer
              // Tambahkan kode logout di sini
            },
          ),
        ],
      ),
    );
  }
}

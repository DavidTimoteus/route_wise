import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/Components/sidebarmenuProfil.dart';
import 'package:route_wise/pages/Profil.dart';
import 'package:route_wise/pages/WelcomeScreen.dart';
import 'package:route_wise/services/app_state.dart';

class DashboardKepalaGudang extends StatefulWidget {
  const DashboardKepalaGudang({super.key});

  @override
  State<DashboardKepalaGudang> createState() => _DashboardKepalaGudangState();
}

class _DashboardKepalaGudangState extends State<DashboardKepalaGudang> {
  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final user = appState.currentUser;
    final firstName = user.fullName.split(' ').first;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      drawer: const MyDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Profil()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            child: ClipOval(
              child: Image.asset(
                'assets/images/ProfilAdmin.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const WelcomeScreen(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(
              FontAwesomeIcons.rightFromBracket,
              color: Color(0xFFE45F2B),
            ),
          ),
        ],
        title: Text(
          'Dashboard',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: const Color(0xFFE45F2B),
            fontSize: 23,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Hi ! $firstName, Here...\n',
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFFE45F2B),
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: 'Delivery Activity :',
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFFE45F2B),
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCounterBadge(
                      icon: FontAwesomeIcons.chartColumn,
                      label: 'Request List',
                      count: appState.requests.length.toString(),
                    ),
                    _buildCounterBadge(
                      icon: FontAwesomeIcons.truck,
                      label: 'Delivery process',
                      count: appState.deliveries.length.toString(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Best Selling',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: const Color(0xFFE45F2B),
                  ),
                ),
              ),
              _buildInfoCard(
                imageAsset: 'assets/images/DjavaOcha.jpg',
                cardTitle: 'Product Information',
                rows: const [
                  MapEntry('Brand', 'Djava Ocha'),
                  MapEntry('Tar', '24,8 Mg'),
                  MapEntry('Nikotin', '1,3 Mg'),
                  MapEntry('Category', 'SKT'),
                  MapEntry('Launch Date', '30-03-2023'),
                  MapEntry('Total Sales', '1.420 Pack'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Top Agent',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: const Color(0xFFE45F2B),
                  ),
                ),
              ),
              _buildInfoCard(
                imageAsset: 'assets/images/AlfaDuro.png',
                cardTitle: 'Agent Information',
                rows: const [
                  MapEntry('Name', 'Alfa Duro'),
                  MapEntry('Order Total', '6.000.000'),
                  MapEntry('Join Date', '30-03-2020'),
                  MapEntry('Best Selling', 'Djava Ocha'),
                  MapEntry('Address', 'Jl Trunojoyo 212'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounterBadge({
    required IconData icon,
    required String label,
    required String count,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: Container(
            width: 50,
            height: 50,
            color: const Color(0xFFF6C445),
            child: Center(
              child: Icon(
                icon,
                size: 26,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '$label\n',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: const Color(0xFFF6C445),
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: count,
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  color: const Color(0xFFF6C445),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String imageAsset,
    required String cardTitle,
    required List<MapEntry<String, String>> rows,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFF6C445),
            offset: Offset(5.0, 5.0),
            blurRadius: 2.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 1,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: 155,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(imageAsset),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cardTitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: const Color(0xFFE45F2B),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Divider(
                  color: Color(0xFFE45F2B),
                  thickness: 2,
                ),
                ...rows.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 95,
                          child: Text(
                            '${entry.key} :',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: const Color(0xFFE45F2B),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: const Color(0xFFE45F2B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

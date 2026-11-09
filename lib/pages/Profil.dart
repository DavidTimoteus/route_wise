import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/Components/text_field.dart';
import 'package:route_wise/pages/KelolaProfil.dart';
import 'package:route_wise/pages/WelcomeScreen.dart';
import 'package:route_wise/services/app_state.dart';

class Profil extends StatelessWidget {
  const Profil({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppStateScope.of(context).currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromARGB(255, 255, 94, 0),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KelolaProfil()),
              );
            },
            icon: const Icon(
              Icons.settings,
              color: Color.fromARGB(255, 255, 94, 0),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                'PROFILE',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 15),
            CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage(user.avatarAsset),
            ),
            const SizedBox(height: 10),
            Text(
              user.fullName,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              user.email,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  inputFile(
                    label: 'Full Name',
                    teks: user.fullName,
                    icon: FontAwesomeIcons.solidCircleUser,
                    labelColor: Colors.grey,
                    iconColor: Colors.black87,
                    readOnly: true,
                  ),
                  inputFile(
                    label: 'E-mail',
                    teks: user.email,
                    icon: FontAwesomeIcons.solidEnvelope,
                    labelColor: Colors.grey,
                    iconColor: Colors.black87,
                    readOnly: true,
                  ),
                  inputFile(
                    label: 'Password',
                    teks: '••••••••',
                    obscureText: true,
                    icon: FontAwesomeIcons.key,
                    labelColor: Colors.grey,
                    iconColor: Colors.black87,
                    readOnly: true,
                  ),
                  inputFile(
                    label: 'Phone Number',
                    teks: user.phoneNumber,
                    icon: FontAwesomeIcons.phone,
                    labelColor: Colors.grey,
                    iconColor: Colors.black87,
                    readOnly: true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SizedBox(
                width: 400,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 94, 0),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(
                    'LOGOUT',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

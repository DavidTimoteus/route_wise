import 'package:flutter/material.dart';
import 'package:route_wise/Pages/KelolaProfil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Profil extends StatelessWidget {
  const Profil({super.key});

  @override
  Widget build(BuildContext context) {
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
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 255, 94, 0),
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KelolaProfil()),
                  );
                }
              },
              icon: Icon(
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
                  "PROFILE",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/images/hero.jpg'),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Ilham Maulana Ahmad",
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                "Maulana@gmail.com",
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold, fontSize: 10),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(29),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    inputFile(
                        label: 'Full Name',
                        teks: 'Ilham Maulana Ahmad',
                        icon: FontAwesomeIcons.solidCircleUser),
                    inputFile(
                        label: 'E-mail',
                        teks: 'Maulana@gmail.com',
                        icon: FontAwesomeIcons.solidEnvelope),
                    inputFile(
                        label: 'Password',
                        teks: '',
                        obscureText: true,
                        icon: FontAwesomeIcons.key),
                    inputFile(
                        label: 'Phone Number',
                        teks: '081352673477',
                        icon: FontAwesomeIcons.phone),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Container(
                    width: 400,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 94, 0),
                      ),
                      onPressed: () {},
                      child: Text("LOGOUT",
                          style: GoogleFonts.montserrat(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    )),
              )
            ],
          ),
        ));
  }
}

Widget inputFile(
    {required label, teks, obscureText = false, required IconData icon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const SizedBox(
        height: 15,
      ),
      Text(
        label,
        style: GoogleFonts.montserrat(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
      ),
      const SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: teks,
          prefixIcon: Icon(
            icon,
            color: Colors.black87,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
    ],
  );
}

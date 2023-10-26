import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/pages/Login.dart';
import 'package:route_wise/pages/WelcomeScreen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()));
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: MediaQuery.of(context).size.height - 100,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      alignment: Alignment.topLeft,
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Let’s Join ",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.black87,
                              ),
                            ),
                            TextSpan(
                              text: "With Us ,\n",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: const Color.fromRGBO(228, 95, 43, 1),
                              ),
                            ),
                            TextSpan(
                              text:
                                  "Create Your Profile for Exploring the Finest Routes",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(29)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 40),
                      child: Column(
                        children: [
                          inputFile(
                              label: 'Full Name',
                              icon: FontAwesomeIcons.solidCircleUser),
                          inputFile(
                              label: 'Email',
                              icon: FontAwesomeIcons.solidEnvelope),
                          inputFile(
                              label: 'Password',
                              obscureText: true,
                              icon: FontAwesomeIcons.key),
                          inputFile(
                              label: 'Phone Number',
                              icon: FontAwesomeIcons.phone),
                          inputFile(
                              label: 'Occupation',
                              icon: FontAwesomeIcons.solidAddressCard)
                        ],
                      ),
                    ),
                    Container(
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()));
                        },
                        color: const Color.fromRGBO(228, 95, 43, 1),
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 5.0,
                                color: Color.fromRGBO(246, 196, 69, 1)),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "SIGN UP",
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have an Account ? ",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Container(
                            child: Text(
                              'Login',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromRGBO(228, 95, 43,
                                      1)), // Atur teks menjadi transparan
                            ),
                          ),
                        )
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 0))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

Widget inputFile(
    {required label, obscureText = false, required IconData icon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const SizedBox(
        height: 5,
      ),
      Text(
        label,
        style: GoogleFonts.montserrat(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
      ),
      const SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.black87,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black87),
            ),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87))),
      ),
    ],
  );
}

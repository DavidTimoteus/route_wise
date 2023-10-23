import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/pages/Login.dart';
import 'package:route_wise/pages/SignUp.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(228, 95, 43, 1),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/DB Route.png"))),
                ),
                const SizedBox(
                  height: 30,
                ),
                RichText(
                  text: TextSpan(
                    // style: GoogleFonts.montserrat(),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'ROUTE ',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 45,
                          fontStyle: FontStyle.italic,
                          color: Color.fromRGBO(246, 196, 69, 1),
                        ),
                      ),
                      TextSpan(
                        text: 'WISE',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 45,
                          fontStyle: FontStyle.italic,
                          color: Colors.white, // Warna putih
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Maximize your fleet's productivity with our optimized route selection!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: <Widget>[
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 5.0,
                              color: Color.fromRGBO(246, 196, 69, 1)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "LOGIN",
                        style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color.fromRGBO(246, 196, 69, 1)),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 60,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          thickness: 5,
                          color: Color.fromRGBO(246, 196, 69, 1),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'OR',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 5,
                          color: Color.fromRGBO(246, 196, 69, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()));
                      },
                      color: const Color.fromRGBO(246, 196, 69, 1),
                      shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(width: 5.0, color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "SIGN UP",
                        style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

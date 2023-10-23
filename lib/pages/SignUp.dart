import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/pages/Login.dart';

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
              Navigator.pop(context);
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: MediaQuery.of(context).size.height - 100,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
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
                                color: Color.fromRGBO(228, 95, 43, 1),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(29)),
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
                        Text(
                          "Login",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(228, 95, 43, 1)),
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 0))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

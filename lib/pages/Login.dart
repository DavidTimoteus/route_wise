import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:route_wise/Pages/SignUp.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/pages/WelcomeScreen.dart';
import 'package:route_wise/Components/text_field.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  bool? _ischecked = false;

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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: MediaQuery.of(context).size.height - 100,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height / 4,
                            padding: EdgeInsets.only(left: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                "assets/images/DB Route.png",
                                fit: BoxFit
                                    .cover, // Jika diperlukan, atur sesuai kebutuhan Anda
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(left: 20),
                            child: RichText(
                              text: const TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Welcome ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Back ,\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35,
                                      color: Color.fromRGBO(
                                          228, 95, 43, 1), // Warna putih
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Make it ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.black87, // Warna putih
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Work, ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Color.fromRGBO(
                                          228, 95, 43, 1), // Warna putih
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Make it ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.black87, // Warna putih
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Right, ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Color.fromRGBO(
                                          228, 95, 43, 1), // Warna putih
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Make it ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.black87, // Warna putih
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Fast !',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Color.fromRGBO(
                                          228, 95, 43, 1), // Warna putih
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              children: [
                                textField(
                                    label: 'Email',
                                    icon: FontAwesomeIcons.solidEnvelope),
                                textField(
                                    label: 'Password',
                                    icon: FontAwesomeIcons.key)
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 20),
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
                                "LOGIN",
                                style: GoogleFonts.aBeeZee(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _ischecked = !_ischecked!;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _ischecked,
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          _ischecked = newValue!;
                                        });
                                      },
                                      activeColor: Colors.orange,
                                    ),
                                    Text(
                                      'Remember Me',
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(right: 60)),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                },
                                child: Container(
                                  padding: EdgeInsets.only(right: 15),
                                  child: Text(
                                    'Forgot Password ?',
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        color: Colors
                                            .black), // Atur teks menjadi transparan
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Don’t Have an Account ?",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUp()));
                                },
                                child: Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Create Account',
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromRGBO(228, 95, 43,
                                            1)), // Atur teks menjadi transparan
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ))
                    ],
                  )),
            ],
          ),
        ));
  }
}

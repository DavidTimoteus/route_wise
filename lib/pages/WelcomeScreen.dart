import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(228, 95, 43, 1),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/DB Route.png"))),
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Route ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 55,
                          fontStyle: FontStyle.italic,
                          color: Color.fromRGBO(246, 196, 69, 1), // Warna hitam
                        ),
                      ),
                      TextSpan(
                        text: 'Wise',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 55,
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
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.white,
                  ),
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
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

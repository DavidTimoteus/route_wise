import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
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
                              color:
                                  Color.fromRGBO(228, 95, 43, 1), // Warna putih
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
                              color:
                                  Color.fromRGBO(228, 95, 43, 1), // Warna putih
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
                              color:
                                  Color.fromRGBO(228, 95, 43, 1), // Warna putih
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
                              color:
                                  Color.fromRGBO(228, 95, 43, 1), // Warna putih
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ))
            ],
          )),
    );
  }
}

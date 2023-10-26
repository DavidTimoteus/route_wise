import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardKepalaGudang extends StatefulWidget {
  const DashboardKepalaGudang({super.key});

  @override
  State<DashboardKepalaGudang> createState() => _DashboardKepalaGudang();
}

class _DashboardKepalaGudang extends State<DashboardKepalaGudang> {
  @override
  Widget build(Object context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Container(
            padding: EdgeInsets.all(14),
            child:
                ClipOval(child: Image.asset('assets/images/ProfilAdmin.jpg'))),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              FontAwesomeIcons.rightFromBracket,
              color: Color(0xFFE45F2B),
            ),
          ),
        ],
        title: Text("Dashboard",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: Color(0xFFE45F2B),
                fontSize: 23)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    alignment: Alignment.topLeft,
                    child: RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: 'Hi ! David, Here...\n',
                          style: GoogleFonts.montserrat(
                              color: Color(0xFFE45F2B), fontSize: 18)),
                      TextSpan(
                          text: 'Delivery Activity :',
                          style: GoogleFonts.montserrat(
                              color: Color(0xFFE45F2B),
                              fontWeight: FontWeight.w500,
                              fontSize: 24))
                    ])),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    alignment: Alignment.topLeft,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipOval(
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              width: 50,
                              height: 50,
                              color: Color(0xFFF6C445),
                              child: Center(
                                child: Icon(
                                  FontAwesomeIcons.chartColumn,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Jarak antara ikon dan teks
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Request List\n',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      color: Color(0xFFF6C445),
                                      fontWeight: FontWeight.w500),
                                ),
                                TextSpan(
                                  text: '212',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 30,
                                      color: Color(0xFFF6C445),
                                      fontWeight: FontWeight.w800),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ClipOval(
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              width: 50,
                              height: 50,
                              color: Color(0xFFF6C445),
                              child: Center(
                                child: Icon(
                                  FontAwesomeIcons.truck,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Jarak antara ikon dan teks
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Delivery process\n',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      color: Color(0xFFF6C445),
                                      fontWeight: FontWeight.w500),
                                ),
                                TextSpan(
                                  text: '212',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 30,
                                      color: Color(0xFFF6C445),
                                      fontWeight: FontWeight.w800),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Best Selling',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Color(0xFFE45F2B)),
                    ),
                  ),
                  Container(
                    height: 175,
                    child: Stack(
                      children: [
                        Positioned(
                            child: Material(
                          child: Container(
                            height: 165,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFFF6C445),
                                    offset: Offset(5.0, 5.0),
                                    blurRadius: 2.0,
                                    spreadRadius: 1.0),
                              ],
                            ),
                          ),
                        )),
                        Positioned(
                          child: Card(
                            elevation: 1,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              height: 161,
                              width: 140,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          'assets/images/DjavaOcha.jpg'))),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 10,
                            left: 150,
                            child: Container(
                              height: 165,
                              width: 195,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Product Information",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 17,
                                        color: Color(0xFFE45F2B),
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Divider(
                                    color: Color(0xFFE45F2B),
                                    thickness: 3,
                                  ),
                                  RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        createTextSpan(
                                            "Brand\t\t\t\t\t\t\t\t\t\t\t\t\t:",
                                            "Djava Ocha"),
                                        createTextSpan(
                                            "Tar\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t:",
                                            "24,8 Mg"),
                                        createTextSpan(
                                            "Nikotin\t\t\t\t\t\t\t\t\t\t\t:",
                                            "1,3 Mg"),
                                        createTextSpan(
                                            "Category\t\t\t\t\t\t\t\t:", "SKT"),
                                        createTextSpan(
                                            "Launch Date\t:", "30-03-2023"),
                                        createTextSpan(
                                            "Total Sales\t\t\t\t\t:", "SKT"),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Top Agent',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Color(0xFFE45F2B)),
                    ),
                  ),
                  Container(
                    height: 175,
                    child: Stack(
                      children: [
                        Positioned(
                            child: Material(
                          child: Container(
                            height: 165,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFFF6C445),
                                    offset: Offset(5.0, 5.0),
                                    blurRadius: 2.0,
                                    spreadRadius: 1.0),
                              ],
                            ),
                          ),
                        )),
                        Positioned(
                          child: Card(
                            elevation: 1,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              height: 161,
                              width: 140,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          'assets/images/AlfaDuro.png'))),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 10,
                            left: 150,
                            child: Container(
                              height: 165,
                              width: 195,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Agent Information",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 17,
                                          color: Color(0xFFE45F2B),
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Divider(
                                      color: Color(0xFFE45F2B),
                                      thickness: 3,
                                    ),
                                    RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          createTextSpan(
                                              "Name\t\t\t\t\t\t\t\t\t\t\t\t\t:",
                                              "Alfa Duro"),
                                          createTextSpan("Order Total\t\t\t:",
                                              "6.000.000"),
                                          createTextSpan(
                                              "Join Date\t\t\t\t\t\t:",
                                              "30-03-2020"),
                                          createTextSpan("Best Selling\t\t:",
                                              "Djava Ocha"),
                                          createTextSpan(
                                              "Address\t\t\t\t\t\t\t\t\t:",
                                              "Jl Trujoyo 212"),
                                        ],
                                      ),
                                    )
                                  ]),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  TextSpan createTextSpan(String title, String content) {
    return TextSpan(
      text: title,
      style: GoogleFonts.montserrat(
        fontSize: 15,
        color: Color(0xFFE45F2B),
        fontWeight: FontWeight.w800,
      ),
      children: <TextSpan>[
        TextSpan(
          text: " ",
        ),
        TextSpan(
          text: content + "\n",
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: Color(0xFFE45F2B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

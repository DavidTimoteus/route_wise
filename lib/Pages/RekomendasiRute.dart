import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RekomendasiRute extends StatefulWidget {
  @override
  _PengelolaanSPKState createState() => _PengelolaanSPKState();
}

class _PengelolaanSPKState extends State<RekomendasiRute> {
  String? selectedvalue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromRGBO(255, 252, 225, 1),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromRGBO(255, 252, 225, 1),
          leading: Container(
              padding: EdgeInsets.all(14),
              child: ClipOval(child: Image.asset('assets/images/hero.jpg'))),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                FontAwesomeIcons.rightFromBracket,
                color: Color.fromARGB(255, 255, 94, 0),
              ),
            ),
          ],
          title: Text("Rekomendasi Rute",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 94, 0),
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Align(
                        alignment:
                            Alignment.centerLeft, // Atur teks di sebelah kiri
                        child: Text(
                          "Nama Agen",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: selectedvalue == null
                                      ? Colors.black
                                      : Color.fromARGB(255, 255, 203, 59),
                                )),
                            child: DropdownButton<String?>(
                                value: selectedvalue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedvalue = (value);
                                  });
                                },
                                underline: SizedBox(),
                                isExpanded: true,
                                items: [
                                  "Toko Arudam",
                                  "Toko Barokah",
                                  "Toko Sejahtera",
                                  "Toko Makmur",
                                  "Toko Abadi"
                                ]
                                    .map<DropdownMenuItem<String>>(
                                        (e) => DropdownMenuItem(
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 7),
                                                  Icon(
                                                    FontAwesomeIcons
                                                        .shop, // Ganti dengan ikon yang Anda inginkan
                                                    color: selectedvalue == null
                                                        ? Colors.black
                                                        : Color.fromARGB(
                                                            255,
                                                            255,
                                                            203,
                                                            59), // Warna ikon
                                                  ),
                                                  SizedBox(width: 15),
                                                  Text(e.toString()),
                                                ],
                                              ),
                                              value: e,
                                            ))
                                    .toList()),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 20,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFE45F2B),
                                  minimumSize: Size(69, 20),
                                ),
                                onPressed: () {},
                                child: Text("ADD",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 20,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFA0E548),
                                  minimumSize: Size(60, 20),
                                ),
                                onPressed: () {},
                                child: Text("FINISH",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                    )),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Divider(
                        thickness: 2,
                        color: Color(0xFFF6C445),
                      ),
                    ),
                  ],
                ),
              ),
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
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
      ),
      const SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: teks,
          prefixIcon: Icon(icon, color: Color.fromARGB(255, 255, 203, 59)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(
                  255, 255, 203, 59), // Border color when focused
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black87, // Border color when not focused
            ),
          ),
        ),
      )
    ],
  );
}

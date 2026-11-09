import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ListPermintaan extends StatefulWidget {
  @override
  _ListPermintaanState createState() => _ListPermintaanState();
}

class _ListPermintaanState extends State<ListPermintaan> {
  String? selectedvalue;
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
              FontAwesomeIcons.circleChevronLeft,
              color: Color(0xFFE45F2B),
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                FontAwesomeIcons.filter,
                color: Color(0xFFE45F2B),
              ),
            ),
          ],
          title: Text("List Permintaan",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE45F2B),
                  fontSize: 23)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                inputFile(
                    label: '',
                    icon: FontAwesomeIcons.search,
                    teks: 'Search...'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "List By Date",
                        style: GoogleFonts.montserrat(
                            color: Color(0xFFE45F2B),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 230,
                  child: Stack(
                    children: [
                      Positioned(
                          child: Material(
                        child: Container(
                          height: 145,
                          width: 400,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 252, 225, 1),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                        ),
                      )),
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Product :',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 50),
                                        child: Text(
                                          'Order Date :',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                  // Memberikan jarak antara teks
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Djava Mild',
                                        style: GoogleFonts.montserrat(),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 42),
                                        child: Text(
                                          '10/22/2023 13:41:05',
                                          style: GoogleFonts.montserrat(),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 39),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            color: Color(0xFF198754),
                                            child: Center(
                                              child: Icon(
                                                FontAwesomeIcons.circleCheck,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Request :',
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 49),
                                            child: Text(
                                              'Destination :',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                      // Memberikan jarak antara teks
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '200 Pack',
                                            style: GoogleFonts.montserrat(),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 53),
                                            child: Text(
                                              'JL Trunojoyo No 212',
                                              style: GoogleFonts.montserrat(),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 28),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Container(
                                                width: 35,
                                                height: 35,
                                                color: Color(0xFFDC3545),
                                                child: Center(
                                                  child: Icon(
                                                    FontAwesomeIcons
                                                        .circleXmark,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

Widget inputFile(
    {required label, teks, obscureText = false, required IconData icon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: GoogleFonts.montserrat(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: teks,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(
                  255, 255, 203, 59), // Ganti dengan warna yang Anda inginkan
            ),
          ),
          filled: true, // Aktifkan latar belakang
          fillColor: Color.fromRGBO(255, 252, 225, 1),
          prefixIcon: IconButton(
            icon: Icon(icon, color: Color.fromARGB(255, 255, 203, 59)),
            onPressed: () {
              // Di sini Anda dapat mengatur tindakan yang akan diambil saat ikon diklik
              // Anda dapat mengembalikan argumen atau melakukan tindakan lainnya
            },
          ),
        ),
      )
    ],
  );
}

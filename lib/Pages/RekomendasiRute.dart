import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class RekomendasiRute extends StatefulWidget {
  @override
  _RekomendasiRuteState createState() => _RekomendasiRuteState();
}

class _RekomendasiRuteState extends State<RekomendasiRute> {
  String? selectedvalue;
  double? _latitude = 0;
  double? _longitude = 0;
  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  GlobalKey _mapKey = GlobalKey();
  bool _mapCreated = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                FontAwesomeIcons.filter,
                color: Color(0xFFE45F2B),
              ),
            ),
          ],
          title: Text("RekomendasiRute",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE45F2B),
                  fontSize: 23)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
         child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
        child: Column(
          children: <Widget>[
            inputFile(
              label: 'NAMA AGENT',
              icon: FontAwesomeIcons.solidCircleUser,
            ),
           SizedBox(height: 20), // Add some space between the input field and buttons
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    ElevatedButton(
      onPressed: () {
        // Add functionality for the "Add" button
      },
      child: Text('Add'),
    ),
    ElevatedButton(
      onPressed: () {
        // Add functionality for the "Finish" button
      },
      child: Text('Finish'),
    ),
  ],
),
     _buildMap(key: _mapKey), 

                Row(
                  mainAxisAlignment: MainAxisAlignment.start, 
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Pilihan Rekomendasi Rute Terbaik",
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
                  child: Stack(
                    children: [
                      Positioned(
                          child: Material(
                        child: Container(
                          height: 130,
                          width: 400,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(210, 255, 2153, 1),
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
                                  horizontal: 15, vertical: 5),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Arudam Djaya sumenep',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 3),
                                        child: Divider(
                                          thickness: 2,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Destination :',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 27),
                                        child: Text(
                                          'Distance :',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 54),
                                        child: Text(
                                          'Request :',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      )
                                    ],
                                  ),
                                  // Memberikan jarak antara teks
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Jl Trunojoyo No 212',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 10),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 32),
                                        child: Text(
                                          '2,5 Km',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 10),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 59),
                                        child: Text(
                                          '912 Permintaan',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 10),
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
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 27),
                                            child: Text(
                                              'Destination :',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 55),
                                            child: Text(
                                              'Expected Date :',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
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
                                            style: GoogleFonts.montserrat(
                                                fontSize: 10),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: Text(
                                              'JL Trunojoyo No 212',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 10),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 36),
                                            child: Text(
                                              '10/22/2023 13:41:05',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 10),
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
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Stack(
                    children: [
                      Positioned(
                          child: Material(
                        child: Container(
                          height: 130,
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
                                  horizontal: 15, vertical: 5),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'On Progress...',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 3),
                                        child: Divider(
                                          thickness: 2,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Product :',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 27),
                                        child: Text(
                                          'Drive Name :',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 54),
                                        child: Text(
                                          'Order Date :',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
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
                                        style: GoogleFonts.montserrat(
                                            fontSize: 10),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 32),
                                        child: Text(
                                          'Ilham Maulana',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 10),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 59),
                                        child: Text(
                                          '10/22/2023 13:41:05',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 10),
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
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 27),
                                            child: Text(
                                              'Destination :',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 55),
                                            child: Text(
                                              'Expected Date :',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
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
                                            style: GoogleFonts.montserrat(
                                                fontSize: 10),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: Text(
                                              'JL Trunojoyo No 212',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 10),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 36),
                                            child: Text(
                                              '10/22/2023 13:41:05',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 10),
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
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 230,
                  child: Stack(
                    children: [
                      Positioned(
                          child: Material(
                        child: Container(
                          height: 130,
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
                                  horizontal: 15, vertical: 5),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'On Progress...',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 3),
                                        child: Divider(
                                          thickness: 2,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Product :',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 27),
                                        child: Text(
                                          'Drive Name :',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 54),
                                        child: Text(
                                          'Order Date :',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
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
                                        style: GoogleFonts.montserrat(
                                            fontSize: 10),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 32),
                                        child: Text(
                                          'Ilham Maulana',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 10),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 59),
                                        child: Text(
                                          '10/22/2023 13:41:05',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 10),
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
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 27),
                                            child: Text(
                                              'Destination :',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 55),
                                            child: Text(
                                              'Expected Date :',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
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
                                            style: GoogleFonts.montserrat(
                                                fontSize: 10),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: Text(
                                              'JL Trunojoyo No 212',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 10),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 36),
                                            child: Text(
                                              '10/22/2023 13:41:05',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 10),
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
                ),
              ],
            ),
          ),
        ));
  }
Widget _buildMap({required Key key}) {
    return Container(
      key: key,
      height: 200,
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          if (!_mapCreated) {
            _controller.complete(controller);
            setState(() {
              _mapCreated = true;
            });
          }
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(_latitude ?? 0, _longitude ?? 0),
          zoom: 15.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId("currentLocation"),
            position: LatLng(_latitude ?? 0, _longitude ?? 0),
            infoWindow: InfoWindow(title: "Current Location"),
          ),
        },
      ),
    );
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

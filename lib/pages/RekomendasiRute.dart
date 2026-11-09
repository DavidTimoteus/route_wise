import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:route_wise/Components/text_field.dart';
import 'package:route_wise/models/route_models.dart';
import 'package:route_wise/services/app_state.dart';
import 'package:route_wise/services/spk_calculator.dart';

class RekomendasiRute extends StatefulWidget {
  const RekomendasiRute({super.key});

  @override
  State<RekomendasiRute> createState() => _RekomendasiRuteState();
}

class _RekomendasiRuteState extends State<RekomendasiRute> {
  static const double _defaultWarehouseLat = -7.0051;
  static const double _defaultWarehouseLng = 113.8626;

  double _latitude = _defaultWarehouseLat;
  double _longitude = _defaultWarehouseLng;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final GlobalKey _mapKey = GlobalKey();
  bool _mapCreated = false;
  final TextEditingController _agentController = TextEditingController();
  String _searchFilter = '';
  Set<Polyline> _polylines = const {};

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _agentController.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    try {
      final status = await Permission.locationWhenInUse.request();
      if (!status.isGranted) return;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!mounted) return;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (_) {
      // Fall back to default Sumenep warehouse coordinates when running on
      // an emulator or desktop target without location services.
    }
  }

  Future<void> _fetchOsrmRoute(SpkAlternative target) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
      '$_longitude,$_latitude;${target.longitude},${target.latitude}'
      '?overview=full&geometries=geojson',
    );
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final routes = decoded['routes'] as List<dynamic>?;
        if (routes != null && routes.isNotEmpty) {
          final geometry =
              routes.first['geometry'] as Map<String, dynamic>? ?? const {};
          final coords = geometry['coordinates'] as List<dynamic>? ?? const [];
          final points = coords
              .map(
                (pair) => LatLng(
                  (pair[1] as num).toDouble(),
                  (pair[0] as num).toDouble(),
                ),
              )
              .toList();
          if (mounted && points.isNotEmpty) {
            setState(() {
              _polylines = {
                Polyline(
                  polylineId: const PolylineId('optimal_route'),
                  color: const Color(0xFFE45F2B),
                  width: 4,
                  points: points,
                ),
              };
            });
            return;
          }
        }
      }
    } catch (_) {
      // Fall back to direct line if offline.
    }

    if (!mounted) return;
    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId('direct_route'),
          color: const Color(0xFFE45F2B),
          width: 4,
          points: [
            LatLng(_latitude, _longitude),
            LatLng(target.latitude, target.longitude),
          ],
        ),
      };
    });
  }

  void _handleAddAgent() {
    final name = _agentController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nama agen terlebih dahulu.')),
      );
      return;
    }

    AppStateScope.of(context).upsertSpkAlternative(
      storeName: name,
      distanceKm: 3.0,
      itemCount: 250,
      estimatedCostRp: 50000,
      travelTimeMinutes: 15,
      destination: 'Jl Trunojoyo No 212',
    );
    _agentController.clear();
    setState(() {
      _searchFilter = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Agen $name ditambahkan ke daftar rute.')),
    );
  }

  void _handleCalculateOptimalRoute() {
    final appState = AppStateScope.of(context);
    appState.recalculateSpkRanking();
    final alternatives = appState.spkAlternatives;
    if (alternatives.isNotEmpty) {
      _fetchOsrmRoute(alternatives.first);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Rute tercepat: ${alternatives.first.storeName} (${alternatives.first.distanceKm} Km)',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final recommendations = appState.spkAlternatives.where((item) {
      final q = _searchFilter.trim().toLowerCase();
      return q.isEmpty ||
          item.storeName.toLowerCase().contains(q) ||
          item.destination.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(255, 252, 225, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(255, 252, 225, 1),
        leading: Container(
          padding: const EdgeInsets.all(14),
          child: ClipOval(child: Image.asset('assets/images/hero.jpg')),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(
              FontAwesomeIcons.filter,
              color: Color(0xFFE45F2B),
            ),
          ),
        ],
        title: Text(
          'RekomendasiRute',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: const Color(0xFFE45F2B),
            fontSize: 23,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: <Widget>[
              inputFile(
                label: 'NAMA AGENT',
                icon: FontAwesomeIcons.solidCircleUser,
                controller: _agentController,
                filled: true,
                onChanged: (value) {
                  setState(() {
                    _searchFilter = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE45F2B),
                    ),
                    onPressed: _handleAddAgent,
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF198754),
                    ),
                    onPressed: _handleCalculateOptimalRoute,
                    child: const Text(
                      'Finish',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildMap(key: _mapKey, alternatives: recommendations),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Pilihan Rekomendasi Rute Terbaik',
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFFE45F2B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              ...recommendations.asMap().entries.map(
                    (entry) => _buildRecommendationCard(
                      entry.value,
                      isTopChoice: entry.key == 0,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
    SpkAlternative item, {
    required bool isTopChoice,
  }) {
    final bgColor = isTopChoice
        ? const Color.fromRGBO(210, 255, 215, 1)
        : const Color.fromRGBO(255, 252, 225, 1);

    final computedDist = SpkCalculator.haversineDistanceKm(
      _latitude,
      _longitude,
      item.latitude,
      item.longitude,
    );
    final displayDist = item.distanceKm > 0 ? item.distanceKm : computedDist;

    return GestureDetector(
      onTap: () => _fetchOsrmRoute(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: isTopChoice ? const Color(0xFF198754) : Colors.black26,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.storeName,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Skor SAW: ${item.sawScore.toStringAsFixed(3)}',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: const Color(0xFFE45F2B),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 3),
              child: Divider(
                thickness: 2,
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildColumn('Destination :', item.destination),
                ),
                Expanded(
                  child: _buildColumn('Distance :', '$displayDist Km'),
                ),
                Expanded(
                  child: _buildColumn(
                    'Request :',
                    '${item.itemCount} Permintaan',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildColumn(
                    'Estimasi Biaya :',
                    'Rp ${item.estimatedCostRp.toStringAsFixed(0)}',
                  ),
                ),
                Expanded(
                  child: _buildColumn(
                    'Waktu Tempuh :',
                    '${item.travelTimeMinutes.toStringAsFixed(0)} Menit',
                  ),
                ),
                Expanded(
                  child: _buildColumn(
                    'Status :',
                    isTopChoice ? 'Rute Prioritas #1' : 'Rute Alternatif',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.montserrat(fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildMap({
    required Key key,
    required List<SpkAlternative> alternatives,
  }) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(_latitude, _longitude),
        infoWindow: const InfoWindow(title: 'Gudang Utama / Lokasi Saat Ini'),
      ),
      ...alternatives.map(
        (item) => Marker(
          markerId: MarkerId(item.id),
          position: LatLng(item.latitude, item.longitude),
          infoWindow: InfoWindow(
            title: item.storeName,
            snippet: '${item.distanceKm} Km - Skor ${item.sawScore}',
          ),
        ),
      ),
    };

    return SizedBox(
      key: key,
      height: 220,
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
          target: LatLng(_latitude, _longitude),
          zoom: 14.0,
        ),
        markers: markers,
        polylines: _polylines,
      ),
    );
  }
}

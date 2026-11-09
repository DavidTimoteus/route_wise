import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:route_wise/models/route_models.dart';
import 'package:route_wise/services/app_state.dart';
import 'package:route_wise/services/spk_calculator.dart';
import 'package:route_wise/theme/app_theme.dart';

class RekomendasiRute extends StatefulWidget {
  const RekomendasiRute({super.key});

  @override
  State<RekomendasiRute> createState() => _RekomendasiRuteState();
}

class _RekomendasiRuteState extends State<RekomendasiRute> {
  static const double _defaultWarehouseLat = -7.983908;
  static const double _defaultWarehouseLng = 112.621391;

  double _latitude = _defaultWarehouseLat;
  double _longitude = _defaultWarehouseLng;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final GlobalKey _mapKey = GlobalKey();
  bool _mapCreated = false;
  final TextEditingController _agentController = TextEditingController();
  String _searchFilter = '';
  Set<Polyline> _polylines = const {};
  String? _selectedStoreName;
  bool _useGoogleMapOnWeb = false;
  double _mapZoomScale = 1.0;

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
      // Fallback to default Malang hub
    }
  }

  Future<void> _fetchOsrmRoute(SpkAlternative target) async {
    setState(() {
      _selectedStoreName = target.storeName;
    });

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
                  color: AppColors.primary,
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
      // Fall back to direct line
    }

    if (!mounted) return;
    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId('direct_route'),
          color: AppColors.primary,
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
        const SnackBar(content: Text('Masukkan nama agen/toko.')),
      );
      return;
    }

    AppStateScope.of(context).upsertSpkAlternative(
      storeName: name,
      distanceKm: 3.2,
      itemCount: 220,
      estimatedCostRp: 48000,
      travelTimeMinutes: 16,
      destination: 'Jl. Dieng No. 12, Malang',
    );
    _agentController.clear();
    setState(() {
      _searchFilter = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.statusGreenAction,
        content: Text('Toko $name berhasil ditambahkan ke daftar rute.'),
      ),
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
          backgroundColor: AppColors.ink,
          content: Text(
            'Rute prioritas #1 terpilih: ${alternatives.first.storeName} (${alternatives.first.distanceKm} Km)',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppTheme.isDesktop(context);
    final appState = AppStateScope.of(context);
    final recommendations = appState.spkAlternatives.where((item) {
      final q = _searchFilter.trim().toLowerCase();
      return q.isEmpty ||
          item.storeName.toLowerCase().contains(q) ||
          item.destination.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.surface,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: AppColors.border, height: 1),
        ),
        title: Text(
          'PENGAMBILAN KEPUTUSAN RUTE ARMADA',
          style: GoogleFonts.robotoMono(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
            letterSpacing: 1.0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              icon: const Icon(Icons.alt_route_rounded, size: 16),
              label: Text(
                'HITUNG RUTE OPTIMAL',
                style: GoogleFonts.robotoMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              onPressed: _handleCalculateOptimalRoute,
            ),
          ),
        ],
      ),
      body: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left Panel: Map & GPS Hub Info
                Expanded(
                  flex: 55,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: AppColors.border, width: 1),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildGpsStatusBar(),
                        Expanded(
                          child: _buildMap(
                            key: _mapKey,
                            alternatives: recommendations,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right Panel: Dispatch Order & Routes
                Expanded(
                  flex: 45,
                  child: Column(
                    children: [
                      _buildAddAgentBar(),
                      Expanded(
                        child: _buildRouteList(recommendations),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildGpsStatusBar(),
                  const SizedBox(height: 12),
                  _buildAddAgentBar(),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 260,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildMap(
                        key: _mapKey,
                        alternatives: recommendations,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRouteList(recommendations),
                ],
              ),
            ),
    );
  }

  Widget _buildGpsStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.my_location_rounded,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'HUB MALANG UTAMA: ${_latitude.toStringAsFixed(4)}, ${_longitude.toStringAsFixed(4)}',
                style: GoogleFonts.robotoMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          StatusStampBadge.approved(label: 'GPS ONLINE'),
        ],
      ),
    );
  }

  Widget _buildAddAgentBar() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _agentController,
              onChanged: (val) {
                setState(() {
                  _searchFilter = val;
                });
              },
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
              decoration: InputDecoration(
                hintText: 'Cari atau ketik nama toko baru...',
                hintStyle: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: AppColors.inkLight,
                ),
                prefixIcon: const Icon(
                  Icons.storefront_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
                filled: true,
                fillColor: AppColors.surfaceMuted,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: _handleAddAgent,
            child: Text(
              '+ TAMBAH',
              style: GoogleFonts.robotoMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteList(List<SpkAlternative> alternatives) {
    if (alternatives.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada alternatif rute.',
          style: GoogleFonts.montserrat(color: AppColors.inkMuted),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: alternatives.length,
      itemBuilder: (context, index) {
        final item = alternatives[index];
        final isTop = index == 0;
        final isSelected = item.storeName == _selectedStoreName;

        final computedDist = SpkCalculator.haversineDistanceKm(
          _latitude,
          _longitude,
          item.latitude,
          item.longitude,
        );
        final displayDist = item.distanceKm > 0 ? item.distanceKm : computedDist;

        return InkWell(
          onTap: () => _fetchOsrmRoute(item),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : isTop
                        ? AppColors.statusGreenBorder
                        : AppColors.border,
                width: isSelected || isTop ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isTop
                        ? AppColors.statusGreenBg
                        : AppColors.surfaceMuted,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                    ),
                    border: const Border(
                      bottom: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isTop
                                  ? AppColors.statusGreenAction
                                  : AppColors.ink,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              'STOP #${index + 1}',
                              style: GoogleFonts.robotoMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.storeName,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Skor SAW: ${item.sawScore.toStringAsFixed(3)}',
                        style: GoogleFonts.robotoMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isTop
                              ? AppColors.statusGreenText
                              : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: LedgerDataCell(
                              label: 'JARAK GUDANG',
                              value: displayDist.toStringAsFixed(2),
                              unit: 'Km',
                            ),
                          ),
                          Expanded(
                            child: LedgerDataCell(
                              label: 'WAKTU TEMPUH',
                              value: item.travelTimeMinutes.toStringAsFixed(0),
                              unit: 'Menit',
                            ),
                          ),
                          Expanded(
                            child: LedgerDataCell(
                              label: 'BIAYA OPERASIONAL',
                              value: 'Rp ${item.estimatedCostRp.toStringAsFixed(0)}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const DashedRule(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.pin_drop_outlined,
                                size: 13,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item.destination,
                                style: GoogleFonts.montserrat(
                                  fontSize: 11,
                                  color: AppColors.inkMuted,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Kapasitas: ${item.itemCount} Pack',
                            style: GoogleFonts.robotoMono(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.inkMuted,
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
        );
      },
    );
  }

  Widget _buildMap({
    required Key key,
    required List<SpkAlternative> alternatives,
  }) {
    if (kIsWeb && !_useGoogleMapOnWeb) {
      return _buildInteractiveVectorMap(alternatives);
    }

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(_latitude, _longitude),
        infoWindow: const InfoWindow(title: 'Gudang Kebonsari (Hub Utama)'),
      ),
      ...alternatives.map(
        (item) => Marker(
          markerId: MarkerId(item.id),
          position: LatLng(item.latitude, item.longitude),
          infoWindow: InfoWindow(
            title: item.storeName,
            snippet: '${item.distanceKm} Km • Skor ${item.sawScore}',
          ),
        ),
      ),
    };

    return Stack(
      children: [
        GoogleMap(
          key: key,
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
            zoom: 13.5,
          ),
          markers: markers,
          polylines: _polylines,
        ),
        if (kIsWeb)
          Positioned(
            top: 10,
            right: 10,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              ),
              icon: const Icon(Icons.map_rounded, size: 14),
              label: const Text('Beralih ke Peta Vektor GPS',
                  style: TextStyle(fontSize: 10)),
              onPressed: () {
                setState(() {
                  _useGoogleMapOnWeb = false;
                });
              },
            ),
          ),
      ],
    );
  }

  Widget _buildInteractiveVectorMap(List<SpkAlternative> alternatives) {
    final selectedAlt = alternatives.firstWhere(
      (a) => a.storeName == _selectedStoreName,
      orElse: () =>
          alternatives.isNotEmpty ? alternatives.first : const SpkAlternative(
        id: '0',
        storeName: 'Pilih Toko',
        destination: '-',
        distanceKm: 0,
        itemCount: 0,
        estimatedCostRp: 0,
        travelTimeMinutes: 0,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEBE5D8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Stack(
        children: [
          // Background Road Grid Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _MapCanvasPainter(
                hubLat: _latitude,
                hubLng: _longitude,
                alternatives: alternatives,
                selectedStore: _selectedStoreName ?? (alternatives.isNotEmpty ? alternatives.first.storeName : null),
                zoomScale: _mapZoomScale,
              ),
            ),
          ),

          // Top Info Status Bar
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.statusGreenAction,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'PETA GPS DISPATCH • OSRM ROUTE ACTIVE',
                        style: GoogleFonts.robotoMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.92),
                    foregroundColor: AppColors.ink,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  icon: const Icon(Icons.language_rounded, size: 13, color: AppColors.primary),
                  label: Text(
                    'Mode Google Maps SDK',
                    style: GoogleFonts.robotoMono(fontSize: 9, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    setState(() {
                      _useGoogleMapOnWeb = true;
                    });
                  },
                ),
              ],
            ),
          ),

          // Interactive Store Pins Click Targets
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                final hubX = w * 0.45;
                final hubY = h * 0.55;

                return Stack(
                  children: [
                    // Hub Marker
                    Positioned(
                      left: hubX - 20,
                      top: hubY - 32,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.ink,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'HUB KEBONSARI',
                              style: GoogleFonts.robotoMono(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Icon(Icons.location_on, size: 28, color: AppColors.primary),
                        ],
                      ),
                    ),

                    // Destination Pins
                    ...alternatives.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final alt = entry.value;
                      final isSelected = alt.storeName == _selectedStoreName ||
                          (_selectedStoreName == null && idx == 0);

                      // Normalized visual offset based on relative coordinates
                      final dLat = (alt.latitude - _latitude) * 4500 * _mapZoomScale;
                      final dLng = (alt.longitude - _longitude) * 4500 * _mapZoomScale;
                      final posX = (hubX + dLng).clamp(20.0, w - 120.0);
                      final posY = (hubY - dLat).clamp(40.0, h - 60.0);

                      return Positioned(
                        left: posX,
                        top: posY,
                        child: GestureDetector(
                          onTap: () {
                            _fetchOsrmRoute(alt);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.statusGreenAction : Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: isSelected ? AppColors.statusGreenBorder : AppColors.border,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.12),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '#${idx + 1} ${alt.storeName}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected ? Colors.white : AppColors.ink,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.pin_drop,
                                size: isSelected ? 26 : 22,
                                color: isSelected ? AppColors.statusGreenAction : AppColors.inkMuted,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),

          // Bottom Route Details Badge
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.alt_route_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Rute Aktif: ${selectedAlt.storeName} (${selectedAlt.distanceKm} Km • ${selectedAlt.travelTimeMinutes.toStringAsFixed(0)} Mnt)',
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Zoom Controls (+ / - / Reset)
          Positioned(
            bottom: 12,
            right: 12,
            child: Column(
              children: [
                _buildZoomBtn(
                  icon: Icons.add,
                  onTap: () {
                    setState(() {
                      if (_mapZoomScale < 2.2) _mapZoomScale += 0.2;
                    });
                  },
                ),
                const SizedBox(height: 4),
                _buildZoomBtn(
                  icon: Icons.remove,
                  onTap: () {
                    setState(() {
                      if (_mapZoomScale > 0.6) _mapZoomScale -= 0.2;
                    });
                  },
                ),
                const SizedBox(height: 4),
                _buildZoomBtn(
                  icon: Icons.my_location,
                  onTap: () {
                    setState(() {
                      _mapZoomScale = 1.0;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomBtn({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 16, color: AppColors.ink),
      ),
    );
  }
}

class _MapCanvasPainter extends CustomPainter {
  final double hubLat;
  final double hubLng;
  final List<SpkAlternative> alternatives;
  final String? selectedStore;
  final double zoomScale;

  _MapCanvasPainter({
    required this.hubLat,
    required this.hubLng,
    required this.alternatives,
    required this.selectedStore,
    required this.zoomScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFDDD6C8)
      ..strokeWidth = 1.0;

    final roadPaint = Paint()
      ..color = const Color(0xFFD3CABE)
      ..strokeWidth = 2.5;

    // Grid lines
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Arterial road lines (Stylized Malang Roads)
    canvas.drawLine(Offset(0, size.height * 0.55), Offset(size.width, size.height * 0.55), roadPaint);
    canvas.drawLine(Offset(size.width * 0.45, 0), Offset(size.width * 0.45, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.25), Offset(size.width, size.height * 0.75), roadPaint);

    final hubX = size.width * 0.45;
    final hubY = size.height * 0.55;

    // Draw Route Polylines to destinations
    for (int i = 0; i < alternatives.length; i++) {
      final alt = alternatives[i];
      final isSelected = alt.storeName == selectedStore || (selectedStore == null && i == 0);

      final dLat = (alt.latitude - hubLat) * 4500 * zoomScale;
      final dLng = (alt.longitude - hubLng) * 4500 * zoomScale;
      final targetX = (hubX + dLng).clamp(20.0, size.width - 120.0);
      final targetY = (hubY - dLat).clamp(40.0, size.height - 60.0);

      if (isSelected) {
        // High-contrast primary route
        final routePaint = Paint()
          ..color = AppColors.primary
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round;

        final path = Path();
        path.moveTo(hubX, hubY);
        // Bezier road curve
        path.quadraticBezierTo(
          (hubX + targetX) / 2 + 20,
          (hubY + targetY) / 2 - 15,
          targetX + 10,
          targetY + 15,
        );
        canvas.drawPath(path, routePaint);
      } else {
        // Subtle alternative route line
        final altRoutePaint = Paint()
          ..color = const Color(0xFFC7BFAF)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
        canvas.drawLine(Offset(hubX, hubY), Offset(targetX + 10, targetY + 15), altRoutePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MapCanvasPainter oldDelegate) {
    return oldDelegate.selectedStore != selectedStore ||
        oldDelegate.zoomScale != zoomScale ||
        oldDelegate.alternatives.length != alternatives.length;
  }
}


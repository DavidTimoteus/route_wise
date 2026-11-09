import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
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

class _MapThemeData {
  final String name;
  final Color bg;
  final Color grid;
  final Color road;
  final Color arterial;
  final Color primaryRoute;
  final Color altRoute;
  final Color hubBadge;
  final Color text;
  final Color cardBg;
  final Color cardBorder;
  final bool isDark;

  const _MapThemeData({
    required this.name,
    required this.bg,
    required this.grid,
    required this.road,
    required this.arterial,
    required this.primaryRoute,
    required this.altRoute,
    required this.hubBadge,
    required this.text,
    required this.cardBg,
    required this.cardBorder,
    required this.isDark,
  });
}

const List<_MapThemeData> _mapThemes = [
  _MapThemeData(
    name: 'KERTAS GUDANG',
    bg: Color(0xFFEBE5D8),
    grid: Color(0xFFDDD6C8),
    road: Color(0xFFD3CABE),
    arterial: Color(0xFFC7BFAF),
    primaryRoute: AppColors.primary,
    altRoute: Color(0xFFB5ABA0),
    hubBadge: AppColors.ink,
    text: AppColors.ink,
    cardBg: Colors.white,
    cardBorder: AppColors.border,
    isDark: false,
  ),
  _MapThemeData(
    name: 'RADAR NIGHT OPS',
    bg: Color(0xFF11161B),
    grid: Color(0xFF1B232C),
    road: Color(0xFF222F3C),
    arterial: Color(0xFF2D3E4F),
    primaryRoute: Color(0xFF10B981),
    altRoute: Color(0xFF3F5468),
    hubBadge: Color(0xFF0F172A),
    text: Color(0xFFF1F5F9),
    cardBg: Color(0xFF1A222C),
    cardBorder: Color(0xFF2E3D4E),
    isDark: true,
  ),
  _MapThemeData(
    name: 'BLUEPRINT CAD',
    bg: Color(0xFF0F2338),
    grid: Color(0xFF193758),
    road: Color(0xFF224873),
    arterial: Color(0xFF2E5E96),
    primaryRoute: Color(0xFF00E5FF),
    altRoute: Color(0xFF3E6999),
    hubBadge: Color(0xFF0A1726),
    text: Color(0xFFF0F6FC),
    cardBg: Color(0xFF162F4C),
    cardBorder: Color(0xFF2B527E),
    isDark: true,
  ),
];

class _RekomendasiRuteState extends State<RekomendasiRute>
    with SingleTickerProviderStateMixin {
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
  Offset _mapPanOffset = Offset.zero;
  int _mapThemeIndex = 0;
  SpkAlternative? _inspectedAlt;
  bool _showTurnByTurn = false;

  late final AnimationController _simController;

  @override
  void initState() {
    super.initState();
    _initLocation();
    _simController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.statusGreenAction,
              content: Text(
                'Armada telah tiba di tujuan: ${_selectedStoreName ?? "Toko Tujuan"}!',
              ),
            ),
          );
        }
      });
  }

  @override
  void dispose() {
    _agentController.dispose();
    _simController.dispose();
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
      _inspectedAlt = target;
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
      _simController.reset();
      _simController.forward();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.ink,
          content: Text(
            'Rute prioritas #1 terpilih: ${alternatives.first.storeName} (${alternatives.first.distanceKm} Km). Simulasi armada dimulai!',
          ),
        ),
      );
    }
  }

  void _toggleSimulation() {
    if (_simController.isAnimating) {
      _simController.stop();
    } else {
      if (_simController.isCompleted) {
        _simController.reset();
      }
      _simController.forward();
    }
    setState(() {});
  }

  void _resetSimulation() {
    _simController.reset();
    setState(() {});
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
                // Left Panel: Interactive Vector Map & Fleet Telematics
                Expanded(
                  flex: 58,
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
                  flex: 42,
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
                    height: 380,
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
          Row(
            children: [
              InkWell(
                onTap: () {
                  _initLocation();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sinyal GPS Hub berhasil diperbarui.'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.sync_rounded, size: 12, color: AppColors.inkMuted),
                      const SizedBox(width: 4),
                      Text(
                        'PING GPS',
                        style: GoogleFonts.robotoMono(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              StatusStampBadge.approved(label: 'GPS ONLINE'),
            ],
          ),
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
    final activeTheme = _mapThemes[_mapThemeIndex];
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
        color: activeTheme.bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: activeTheme.cardBorder, width: 1),
      ),
      child: Column(
        children: [
          // 1. Quick Stop Strip (Horizontal Quick Destination Selector)
          _buildQuickStopStrip(alternatives, activeTheme),

          // 2. Main Interactive Canvas Area
          Expanded(
            child: Stack(
              children: [
                // Gesture Controlled Vector Canvas (Supports Drag / Pan)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanUpdate: (details) {
                      setState(() {
                        _mapPanOffset += details.delta;
                      });
                    },
                    child: CustomPaint(
                      painter: _MapCanvasPainter(
                        hubLat: _latitude,
                        hubLng: _longitude,
                        alternatives: alternatives,
                        selectedStore: _selectedStoreName ??
                            (alternatives.isNotEmpty
                                ? alternatives.first.storeName
                                : null),
                        zoomScale: _mapZoomScale,
                        panOffset: _mapPanOffset,
                        theme: activeTheme,
                        simProgress: _simController.value,
                      ),
                    ),
                  ),
                ),

                // Top Toolbar: Status, Theme Switcher & Map Mode
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: _buildMapToolbar(activeTheme),
                ),

                // Interactive Store Pins & Hub Markers Overlay
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return _buildMapMarkersOverlay(
                        constraints: constraints,
                        alternatives: alternatives,
                        selectedAlt: selectedAlt,
                        theme: activeTheme,
                      );
                    },
                  ),
                ),

                // Animated Fleet Delivery Vehicle Marker
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return _buildAnimatedTruckOverlay(
                        constraints: constraints,
                        selectedAlt: selectedAlt,
                        theme: activeTheme,
                      );
                    },
                  ),
                ),

                // Waypoint Inspection Popover (when a pin is tapped)
                if (_inspectedAlt != null)
                  Positioned(
                    top: 54,
                    right: 12,
                    child: _buildInspectionCard(_inspectedAlt!, activeTheme),
                  ),

                // Turn-by-Turn Waypoint Guidance Sheet (collapsible)
                if (_showTurnByTurn)
                  Positioned(
                    bottom: 80,
                    left: 12,
                    child: _buildTurnByTurnGuidance(selectedAlt, activeTheme),
                  ),

                // Bottom Left: Fleet Telematics HUD
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 70,
                  child: _buildTelematicsHud(selectedAlt, activeTheme),
                ),

                // Bottom Right: Zoom & Reset Pan Controls
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: _buildMapControls(activeTheme),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStopStrip(
    List<SpkAlternative> alternatives,
    _MapThemeData theme,
  ) {
    if (alternatives.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.isDark ? const Color(0xFF0D1117) : const Color(0xFFDFD8C8),
        border: Border(
          bottom: BorderSide(color: theme.cardBorder),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: alternatives.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, idx) {
          final alt = alternatives[idx];
          final isSel = alt.storeName == _selectedStoreName ||
              (_selectedStoreName == null && idx == 0);

          return InkWell(
            onTap: () {
              setState(() {
                _selectedStoreName = alt.storeName;
                _inspectedAlt = alt;
              });
              _fetchOsrmRoute(alt);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isSel ? theme.primaryRoute : theme.cardBg,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSel ? theme.primaryRoute : theme.cardBorder,
                  width: isSel ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: isSel
                          ? (theme.isDark ? Colors.black : Colors.white)
                          : theme.primaryRoute,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      '#${idx + 1}',
                      style: GoogleFonts.robotoMono(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: isSel
                            ? (theme.isDark ? Colors.white : theme.primaryRoute)
                            : Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    alt.storeName,
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isSel
                          ? (theme.isDark ? Colors.black : Colors.white)
                          : theme.text,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${alt.distanceKm} Km',
                    style: GoogleFonts.robotoMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: isSel
                          ? (theme.isDark ? Colors.black87 : Colors.white70)
                          : theme.text.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapToolbar(_MapThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Live GPS Status Indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.cardBg.withOpacity(0.92),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: theme.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.statusGreenAction,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'OSRM CARTOGRAPHY RADAR',
                style: GoogleFonts.robotoMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: theme.text,
                ),
              ),
            ],
          ),
        ),

        // Controls: Theme Switcher & Map Mode
        Row(
          children: [
            // Theme Selector
            InkWell(
              onTap: () {
                setState(() {
                  _mapThemeIndex = (_mapThemeIndex + 1) % _mapThemes.length;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: theme.cardBg.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: theme.cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.palette_outlined, size: 12, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      theme.name,
                      style: GoogleFonts.robotoMono(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: theme.text,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Google Maps Mode Switcher
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.cardBg.withOpacity(0.92),
                foregroundColor: theme.text,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                side: BorderSide(color: theme.cardBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              icon: const Icon(Icons.language_rounded, size: 12, color: AppColors.primary),
              label: Text(
                'Google SDK',
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
      ],
    );
  }

  Widget _buildMapMarkersOverlay({
    required BoxConstraints constraints,
    required List<SpkAlternative> alternatives,
    required SpkAlternative selectedAlt,
    required _MapThemeData theme,
  }) {
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    final hubX = w * 0.45 + _mapPanOffset.dx;
    final hubY = h * 0.55 + _mapPanOffset.dy;

    return Stack(
      children: [
        // Hub Kebonsari Marker
        Positioned(
          left: hubX - 45,
          top: hubY - 36,
          child: InkWell(
            onTap: () {
              setState(() {
                _mapPanOffset = Offset.zero;
                _mapZoomScale = 1.0;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kamera dipusatkan kembali ke Hub Kebonsari.'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.hubBadge,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: theme.cardBorder),
                  ),
                  child: Text(
                    'HUB MALANG',
                    style: GoogleFonts.robotoMono(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(
                  Icons.warehouse_rounded,
                  size: 24,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),

        // Destination Pins
        ...alternatives.asMap().entries.map((entry) {
          final idx = entry.key;
          final alt = entry.value;
          final isSelected = alt.storeName == _selectedStoreName ||
              (_selectedStoreName == null && idx == 0);

          final dLat = (alt.latitude - _latitude) * 4500 * _mapZoomScale;
          final dLng = (alt.longitude - _longitude) * 4500 * _mapZoomScale;
          final posX = hubX + dLng;
          final posY = hubY - dLat;

          return Positioned(
            left: posX - 35,
            top: posY - 36,
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
                      color: isSelected ? theme.primaryRoute : theme.cardBg,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected ? theme.primaryRoute : theme.cardBorder,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
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
                        color: isSelected
                            ? (theme.isDark ? Colors.black : Colors.white)
                            : theme.text,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.pin_drop_rounded,
                    size: isSelected ? 28 : 22,
                    color: isSelected ? theme.primaryRoute : theme.text.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAnimatedTruckOverlay({
    required BoxConstraints constraints,
    required SpkAlternative selectedAlt,
    required _MapThemeData theme,
  }) {
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    final hubX = w * 0.45 + _mapPanOffset.dx;
    final hubY = h * 0.55 + _mapPanOffset.dy;

    final dLat = (selectedAlt.latitude - _latitude) * 4500 * _mapZoomScale;
    final dLng = (selectedAlt.longitude - _longitude) * 4500 * _mapZoomScale;
    final targetX = hubX + dLng;
    final targetY = hubY - dLat;

    final p0 = Offset(hubX, hubY);
    final p2 = Offset(targetX, targetY);
    final p1 = Offset(
      (hubX + targetX) / 2 + 20 * _mapZoomScale,
      (hubY + targetY) / 2 - 15 * _mapZoomScale,
    );

    final t = _simController.value;
    final truckPos = _evalBezier(p0, p1, p2, t);
    final truckAngle = _evalBezierAngle(p0, p1, p2, t);

    final isMoving = _simController.isAnimating;
    final currentSpeed = isMoving
        ? (38.0 + math.sin(t * 12) * 8.0).toStringAsFixed(0)
        : (t >= 1.0 ? '0' : '0');

    return Stack(
      children: [
        Positioned(
          left: truckPos.dx - 22,
          top: truckPos.dy - 34,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Speed & Status Floating Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isMoving ? AppColors.statusGreenAction : AppColors.ink,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  isMoving ? '$currentSpeed Km/h' : (t >= 1.0 ? 'TIBA' : 'STANDBY'),
                  style: GoogleFonts.robotoMono(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 2),

              // Rotated Delivery Truck Icon with Radar Pulse
              Stack(
                alignment: Alignment.center,
                children: [
                  if (isMoving)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.primaryRoute.withOpacity(0.3),
                      ),
                    ),
                  Transform.rotate(
                    angle: truckAngle,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.local_shipping_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInspectionCard(SpkAlternative alt, _MapThemeData theme) {
    return Container(
      width: 270,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardBg.withOpacity(0.96),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.primaryRoute, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'INSPEKSI WAYPOINT',
                style: GoogleFonts.robotoMono(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: theme.primaryRoute,
                  letterSpacing: 0.8,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _inspectedAlt = null;
                  });
                },
                child: Icon(Icons.close_rounded, size: 16, color: theme.text),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            alt.storeName,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: theme.text,
            ),
          ),
          Text(
            alt.destination,
            style: GoogleFonts.montserrat(
              fontSize: 10,
              color: theme.text.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniMetric('JARAK', '${alt.distanceKm} Km', theme),
              _buildMiniMetric('WAKTU', '${alt.travelTimeMinutes.toStringAsFixed(0)} Mnt', theme),
              _buildMiniMetric('SKOR SAW', alt.sawScore.toStringAsFixed(3), theme),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryRoute,
                    foregroundColor: theme.isDark ? Colors.black : Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, size: 14),
                  label: Text(
                    'SIMULASI',
                    style: GoogleFonts.robotoMono(fontSize: 10, fontWeight: FontWeight.w800),
                  ),
                  onPressed: () {
                    _fetchOsrmRoute(alt);
                    _simController.reset();
                    _simController.forward();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetric(String label, String val, _MapThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoMono(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            color: theme.text.withOpacity(0.5),
          ),
        ),
        Text(
          val,
          style: GoogleFonts.robotoMono(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: theme.text,
          ),
        ),
      ],
    );
  }

  Widget _buildTelematicsHud(SpkAlternative selectedAlt, _MapThemeData theme) {
    final t = _simController.value;
    final isMoving = _simController.isAnimating;
    final progressPct = (t * 100).toInt();
    final etaRemaining = ((1.0 - t) * selectedAlt.travelTimeMinutes).ceil();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.cardBg.withOpacity(0.96),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isMoving
                      ? AppColors.statusGreenAction
                      : (t >= 1.0 ? AppColors.ink : AppColors.primary),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  isMoving
                      ? Icons.navigation_rounded
                      : (t >= 1.0 ? Icons.check_circle_rounded : Icons.local_shipping_rounded),
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RUTE AKTIF: ${selectedAlt.storeName.toUpperCase()}',
                      style: GoogleFonts.robotoMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: theme.text,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${selectedAlt.distanceKm} Km • ETA: $etaRemaining Mnt • Progres: $progressPct%',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: theme.text.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              // Simulation Controls
              Row(
                children: [
                  IconButton(
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      isMoving ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                      color: theme.primaryRoute,
                    ),
                    tooltip: isMoving ? 'Jeda Simulasi' : 'Jalankan Simulasi',
                    onPressed: _toggleSimulation,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(Icons.restart_alt_rounded, color: theme.text.withOpacity(0.7)),
                    tooltip: 'Reset Simulasi',
                    onPressed: _resetSimulation,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      _showTurnByTurn ? Icons.map_rounded : Icons.alt_route_rounded,
                      color: _showTurnByTurn ? theme.primaryRoute : theme.text.withOpacity(0.7),
                    ),
                    tooltip: 'Panduan Langkah Rute',
                    onPressed: () {
                      setState(() {
                        _showTurnByTurn = !_showTurnByTurn;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: t,
              minHeight: 4,
              backgroundColor: theme.grid,
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryRoute),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTurnByTurnGuidance(SpkAlternative alt, _MapThemeData theme) {
    return Container(
      width: 290,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardBg.withOpacity(0.96),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PANDUAN LANGKAH (MANIFES)',
                style: GoogleFonts.robotoMono(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: theme.primaryRoute,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _showTurnByTurn = false;
                  });
                },
                child: Icon(Icons.close_rounded, size: 14, color: theme.text),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildStepItem('1', 'Start Hub Kebonsari', 'Ambil jalur keluar ke arah koridor logistik utara', '0.0 Km', theme),
          _buildStepItem('2', 'Arteri Malang Ringroad', 'Lurus mengikuti jalur arteri utama', '1.2 Km', theme),
          _buildStepItem('3', 'Akses Toko Tujuan', 'Belok kiri memasuki kawasan pengiriman ${alt.destination}', '${alt.distanceKm} Km', theme),
          _buildStepItem('4', 'Tiba di Drop-off', 'Bongkar muatan ${alt.itemCount} Pack di ${alt.storeName}', 'Selesai', theme),
        ],
      ),
    );
  }

  Widget _buildStepItem(String step, String title, String desc, String dist, _MapThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: theme.primaryRoute,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: GoogleFonts.robotoMono(
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  color: theme.isDark ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: theme.text,
                      ),
                    ),
                    Text(
                      dist,
                      style: GoogleFonts.robotoMono(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryRoute,
                      ),
                    ),
                  ],
                ),
                Text(
                  desc,
                  style: GoogleFonts.montserrat(
                    fontSize: 9,
                    color: theme.text.withOpacity(0.65),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControls(_MapThemeData theme) {
    return Column(
      children: [
        _buildZoomBtn(
          icon: Icons.add,
          tooltip: 'Zoom In',
          theme: theme,
          onTap: () {
            setState(() {
              if (_mapZoomScale < 2.4) _mapZoomScale += 0.2;
            });
          },
        ),
        const SizedBox(height: 4),
        _buildZoomBtn(
          icon: Icons.remove,
          tooltip: 'Zoom Out',
          theme: theme,
          onTap: () {
            setState(() {
              if (_mapZoomScale > 0.6) _mapZoomScale -= 0.2;
            });
          },
        ),
        const SizedBox(height: 4),
        _buildZoomBtn(
          icon: Icons.my_location_rounded,
          tooltip: 'Pusatkan & Reset Geser',
          theme: theme,
          onTap: () {
            setState(() {
              _mapZoomScale = 1.0;
              _mapPanOffset = Offset.zero;
            });
          },
        ),
      ],
    );
  }

  Widget _buildZoomBtn({
    required IconData icon,
    required String tooltip,
    required _MapThemeData theme,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Tooltip(
        message: tooltip,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: theme.cardBg.withOpacity(0.95),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: theme.cardBorder),
          ),
          child: Icon(icon, size: 16, color: theme.text),
        ),
      ),
    );
  }

  static Offset _evalBezier(Offset p0, Offset p1, Offset p2, double t) {
    final oneMinusT = 1.0 - t;
    final x = oneMinusT * oneMinusT * p0.dx +
        2 * oneMinusT * t * p1.dx +
        t * t * p2.dx;
    final y = oneMinusT * oneMinusT * p0.dy +
        2 * oneMinusT * t * p1.dy +
        t * t * p2.dy;
    return Offset(x, y);
  }

  static double _evalBezierAngle(Offset p0, Offset p1, Offset p2, double t) {
    final dx = 2 * (1.0 - t) * (p1.dx - p0.dx) + 2 * t * (p2.dx - p1.dx);
    final dy = 2 * (1.0 - t) * (p1.dy - p0.dy) + 2 * t * (p2.dy - p1.dy);
    return math.atan2(dy, dx);
  }
}

class _MapCanvasPainter extends CustomPainter {
  final double hubLat;
  final double hubLng;
  final List<SpkAlternative> alternatives;
  final String? selectedStore;
  final double zoomScale;
  final Offset panOffset;
  final _MapThemeData theme;
  final double simProgress;

  _MapCanvasPainter({
    required this.hubLat,
    required this.hubLng,
    required this.alternatives,
    required this.selectedStore,
    required this.zoomScale,
    required this.panOffset,
    required this.theme,
    required this.simProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Fill background
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = theme.bg,
    );

    final gridPaint = Paint()
      ..color = theme.grid
      ..strokeWidth = 1.0;

    final roadPaint = Paint()
      ..color = theme.road
      ..strokeWidth = 2.5;

    final arterialPaint = Paint()
      ..color = theme.arterial
      ..strokeWidth = 4.0;

    // Grid lines with pan offset
    final offsetX = panOffset.dx % 40;
    final offsetY = panOffset.dy % 40;
    for (double x = offsetX; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = offsetY; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final hubX = size.width * 0.45 + panOffset.dx;
    final hubY = size.height * 0.55 + panOffset.dy;

    // Arterial roads passing near hub
    canvas.drawLine(
      Offset(0, hubY),
      Offset(size.width, hubY),
      arterialPaint,
    );
    canvas.drawLine(
      Offset(hubX, 0),
      Offset(hubX, size.height),
      arterialPaint,
    );
    canvas.drawLine(
      Offset(hubX - 220, hubY + 160),
      Offset(hubX + 260, hubY - 180),
      roadPaint,
    );
    canvas.drawLine(
      Offset(hubX - 180, hubY - 140),
      Offset(hubX + 200, hubY + 170),
      roadPaint,
    );

    // Radar concentric circles around hub
    final radarPaint = Paint()
      ..color = theme.primaryRoute.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(Offset(hubX, hubY), 45 * zoomScale, radarPaint);
    canvas.drawCircle(Offset(hubX, hubY), 95 * zoomScale, radarPaint);
    canvas.drawCircle(Offset(hubX, hubY), 160 * zoomScale, radarPaint);

    // Draw route paths
    for (int i = 0; i < alternatives.length; i++) {
      final alt = alternatives[i];
      final isSelected = alt.storeName == selectedStore ||
          (selectedStore == null && i == 0);

      final dLat = (alt.latitude - hubLat) * 4500 * zoomScale;
      final dLng = (alt.longitude - hubLng) * 4500 * zoomScale;
      final targetX = hubX + dLng;
      final targetY = hubY - dLat;

      final p0 = Offset(hubX, hubY);
      final p2 = Offset(targetX, targetY);
      final p1 = Offset(
        (hubX + targetX) / 2 + 20 * zoomScale,
        (hubY + targetY) / 2 - 15 * zoomScale,
      );

      final path = Path();
      path.moveTo(p0.dx, p0.dy);
      path.quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);

      if (isSelected) {
        // High-contrast primary route outer glow
        final glowPaint = Paint()
          ..color = theme.primaryRoute.withOpacity(0.25)
          ..strokeWidth = 8.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
        canvas.drawPath(path, glowPaint);

        // Core primary route
        final routePaint = Paint()
          ..color = theme.primaryRoute
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
        canvas.drawPath(path, routePaint);

        // Animated trail dots on active route
        final trailPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        for (double t = 0.1; t <= 0.9; t += 0.2) {
          final adjustedT = (t + simProgress * 0.5) % 1.0;
          final dotPos = _RekomendasiRuteState._evalBezier(p0, p1, p2, adjustedT);
          canvas.drawCircle(dotPos, 2.5, trailPaint);
        }
      } else {
        // Inactive alternative route
        final altRoutePaint = Paint()
          ..color = theme.altRoute.withOpacity(0.6)
          ..strokeWidth = 1.8
          ..style = PaintingStyle.stroke;
        canvas.drawPath(path, altRoutePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MapCanvasPainter oldDelegate) {
    return oldDelegate.selectedStore != selectedStore ||
        oldDelegate.zoomScale != zoomScale ||
        oldDelegate.panOffset != panOffset ||
        oldDelegate.theme != theme ||
        oldDelegate.simProgress != simProgress ||
        oldDelegate.alternatives.length != alternatives.length;
  }
}

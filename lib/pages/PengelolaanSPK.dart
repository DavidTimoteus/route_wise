import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/Components/text_field.dart';
import 'package:route_wise/models/route_models.dart';
import 'package:route_wise/services/app_state.dart';
import 'package:route_wise/theme/app_theme.dart';

class PengelolaanSPK extends StatefulWidget {
  const PengelolaanSPK({super.key});

  @override
  State<PengelolaanSPK> createState() => _PengelolaanSPKState();
}

class _PengelolaanSPKState extends State<PengelolaanSPK> {
  String? _selectedStore;
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _itemsController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  static const List<String> _storeOptions = [
    'Toko Arudam',
    'Toko Barokah',
    'Toko Sejahtera',
    'Toko Makmur',
    'Toko Abadi',
  ];

  @override
  void dispose() {
    _distanceController.dispose();
    _itemsController.dispose();
    _costController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _onSelectStore(String? storeName) {
    setState(() {
      _selectedStore = storeName;
    });
    if (storeName == null) return;

    final alternatives = AppStateScope.of(context).spkAlternatives;
    for (final alt in alternatives) {
      if (alt.storeName.toLowerCase() == storeName.toLowerCase()) {
        _distanceController.text = alt.distanceKm.toString();
        _itemsController.text = alt.itemCount.toString();
        _costController.text = alt.estimatedCostRp.toStringAsFixed(0);
        _timeController.text = alt.travelTimeMinutes.toStringAsFixed(0);
        return;
      }
    }
    _distanceController.clear();
    _itemsController.clear();
    _costController.clear();
    _timeController.clear();
  }

  void _handleAddAlternative() {
    final storeName = _selectedStore;
    if (storeName == null || storeName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih toko alternatif terlebih dahulu.'),
        ),
      );
      return;
    }

    final distance = double.tryParse(_distanceController.text.trim()) ?? 0;
    final items = int.tryParse(_itemsController.text.trim()) ?? 0;
    final cost = double.tryParse(_costController.text.trim()) ?? 0;
    final time = double.tryParse(_timeController.text.trim()) ?? 0;

    if (distance <= 0 || items <= 0 || cost <= 0 || time <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nilai numerik positif untuk semua kriteria.'),
        ),
      );
      return;
    }

    AppStateScope.of(context).upsertSpkAlternative(
      storeName: storeName,
      distanceKm: distance,
      itemCount: items,
      estimatedCostRp: cost,
      travelTimeMinutes: time,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.statusGreenAction,
        content: Text('Kriteria alternatif $storeName tersimpan ke matriks SAW.'),
      ),
    );
  }

  void _handleFinishCalculation() {
    AppStateScope.of(context).recalculateSpkRanking();
    final top = AppStateScope.of(context).spkAlternatives;
    if (top.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.ink,
          content: Text(
            'Kalkulasi SAW Selesai • Rekomendasi Utama: ${top.first.storeName} (Skor: ${top.first.sawScore.toStringAsFixed(3)})',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppTheme.isDesktop(context);
    final alternatives = AppStateScope.of(context).spkAlternatives;

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
          'SISTEM PENDUKUNG KEPUTUSAN (SAW)',
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
                backgroundColor: AppColors.statusGreenAction,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              icon: const Icon(Icons.calculate_outlined, size: 16),
              label: Text(
                'HITUNG NORMALISASI SAW',
                style: GoogleFonts.robotoMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              onPressed: _handleFinishCalculation,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // SAW Weight Ledger Bar
                _buildWeightLedgerBar(),
                const SizedBox(height: 18),

                // Main Content (2-Column Grid on Web, Stacked on Mobile)
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form Input Kriteria
                      Expanded(
                        flex: 45,
                        child: _buildInputFormCard(),
                      ),
                      const SizedBox(width: 18),
                      // Ranked Matrix & Scores
                      Expanded(
                        flex: 55,
                        child: _buildRankingsCard(alternatives),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildInputFormCard(),
                      const SizedBox(height: 18),
                      _buildRankingsCard(alternatives),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeightLedgerBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
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
                    const Icon(Icons.tune_rounded,
                        size: 13, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'PITA BOBOT & TIPE KRITERIA METODE SAW',
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                Text(
                  'TOTAL BOBOT: 100%',
                  style: GoogleFonts.robotoMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.amberText,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: const [
                Expanded(
                  child: LedgerDataCell(
                    label: 'C1 • Jarak Tempuh',
                    value: '30%',
                    unit: '[Cost]',
                  ),
                ),
                Expanded(
                  child: LedgerDataCell(
                    label: 'C2 • Banyak Barang',
                    value: '25%',
                    unit: '[Benefit]',
                  ),
                ),
                Expanded(
                  child: LedgerDataCell(
                    label: 'C3 • Estimasi Biaya',
                    value: '20%',
                    unit: '[Cost]',
                  ),
                ),
                Expanded(
                  child: LedgerDataCell(
                    label: 'C4 • Waktu Tempuh',
                    value: '25%',
                    unit: '[Cost]',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFormCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Input Nilai Kriteria Toko',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  'MATRIKS X',
                  style: GoogleFonts.robotoMono(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.inkMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            'PILIH TOKO / AGEN ALTERNATIF:',
            style: GoogleFonts.robotoMono(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.inkMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _selectedStore == null
                    ? AppColors.border
                    : AppColors.primary,
                width: 1.5,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                value: _selectedStore,
                hint: Text(
                  '-- Pilih Toko Alternatif --',
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: AppColors.inkLight,
                  ),
                ),
                onChanged: _onSelectStore,
                isExpanded: true,
                items: _storeOptions
                    .map<DropdownMenuItem<String>>(
                      (store) => DropdownMenuItem(
                        value: store,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.storefront_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              store,
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          textField(
            label: 'C1: Jarak Tempuh (Km) • [Cost]',
            icon: Icons.add_road_rounded,
            controller: _distanceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hintText: 'Contoh: 2.8',
          ),
          const SizedBox(height: 12),
          textField(
            label: 'C2: Banyak Barang (Pack) • [Benefit]',
            icon: Icons.inventory_2_rounded,
            controller: _itemsController,
            keyboardType: TextInputType.number,
            hintText: 'Contoh: 220',
          ),
          const SizedBox(height: 12),
          textField(
            label: 'C3: Estimasi Biaya (Rp) • [Cost]',
            icon: Icons.monetization_on_rounded,
            controller: _costController,
            keyboardType: TextInputType.number,
            hintText: 'Contoh: 45000',
          ),
          const SizedBox(height: 12),
          textField(
            label: 'C4: Waktu Tempuh (Menit) • [Cost]',
            icon: Icons.hourglass_empty_rounded,
            controller: _timeController,
            keyboardType: TextInputType.number,
            hintText: 'Contoh: 15',
          ),
          const SizedBox(height: 24),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            icon: const Icon(Icons.save_rounded, size: 16),
            label: Text(
              'SIMPAN KE MATRIKS ALTERNATIF',
              style: GoogleFonts.robotoMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            onPressed: _handleAddAlternative,
          ),
        ],
      ),
    );
  }

  Widget _buildRankingsCard(List<SpkAlternative> alternatives) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    const Icon(Icons.leaderboard_rounded,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'HASIL PERANGKINGAN SAW (PREFERENSI Vi)',
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${alternatives.length} ALTERNATIF',
                  style: GoogleFonts.robotoMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),

          if (alternatives.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Text(
                  'Belum ada data alternatif toko. Masukkan kriteria di kolom sebelah kiri.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: AppColors.inkMuted,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: alternatives.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final rank = index + 1;
                final item = alternatives[index];
                final isWinner = rank == 1;

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isWinner
                        ? AppColors.statusGreenBg
                        : AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isWinner
                          ? AppColors.statusGreenBorder
                          : AppColors.border,
                      width: isWinner ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: isWinner
                                      ? AppColors.statusGreenAction
                                      : AppColors.ink,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '#$rank',
                                  style: GoogleFonts.robotoMono(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                item.storeName,
                                style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            item.sawScore.toStringAsFixed(3),
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: isWinner
                                  ? AppColors.statusGreenText
                                  : AppColors.primary,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Score Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: item.sawScore.clamp(0.0, 1.0),
                          backgroundColor: Colors.black.withOpacity(0.08),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isWinner
                                ? AppColors.statusGreenAction
                                : AppColors.primary,
                          ),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Specs
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Jarak: ${item.distanceKm} Km',
                            style: GoogleFonts.robotoMono(
                              fontSize: 11,
                              color: AppColors.inkMuted,
                            ),
                          ),
                          Text(
                            'Muatan: ${item.itemCount} Pack',
                            style: GoogleFonts.robotoMono(
                              fontSize: 11,
                              color: AppColors.inkMuted,
                            ),
                          ),
                          Text(
                            'Biaya: Rp ${item.estimatedCostRp.toStringAsFixed(0)}',
                            style: GoogleFonts.robotoMono(
                              fontSize: 11,
                              color: AppColors.inkMuted,
                            ),
                          ),
                          Text(
                            'Waktu: ${item.travelTimeMinutes.toStringAsFixed(0)} mnt',
                            style: GoogleFonts.robotoMono(
                              fontSize: 11,
                              color: AppColors.inkMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

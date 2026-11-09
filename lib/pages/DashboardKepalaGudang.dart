import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/Components/sidebarmenuProfil.dart';
import 'package:route_wise/models/route_models.dart';
import 'package:route_wise/pages/Profil.dart';
import 'package:route_wise/services/app_state.dart';
import 'package:route_wise/theme/app_theme.dart';

class DashboardKepalaGudang extends StatefulWidget {
  const DashboardKepalaGudang({super.key});

  @override
  State<DashboardKepalaGudang> createState() => _DashboardKepalaGudangState();
}

class _DashboardKepalaGudangState extends State<DashboardKepalaGudang> {
  bool _isSyncing = false;

  void _triggerOdooSync() async {
    setState(() {
      _isSyncing = true;
    });
    final appState = AppStateScope.of(context);
    final count = await appState.syncWithOdoo();
    if (!mounted) return;
    setState(() {
      _isSyncing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.ink,
        content: Row(
          children: [
            const Icon(Icons.sync_alt, color: AppColors.amberStamp, size: 18),
            const SizedBox(width: 10),
            Text(
              'Sinkronisasi Odoo ERP Berhasil ($count pesanan termutakhirkan)',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final user = appState.currentUser;
    final isDesktop = AppTheme.isDesktop(context);

    // Calculate metrics
    final totalRequests = appState.requests.length;
    final inTransitCount = appState.deliveries
        .where((d) => d.status == DeliveryStatus.onProgress)
        .length;
    final deliveredCount = appState.deliveries
        .where((d) => d.status == DeliveryStatus.success)
        .length;
    final bestScore = appState.spkAlternatives.isNotEmpty
        ? appState.spkAlternatives.first.sawScore.toStringAsFixed(3)
        : '0.892';

    return Scaffold(
      backgroundColor: AppColors.canvas,
      drawer: isDesktop ? null : const MyDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.surface,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: AppColors.border, height: 1),
        ),
        leading: isDesktop
            ? null
            : Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu_rounded, color: AppColors.ink),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
        title: Row(
          children: [
            Text(
              'PAPAN KENDALI GUDANG',
              style: GoogleFonts.robotoMono(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.primary),
              ),
              child: Text(
                'LIVE HUB',
                style: GoogleFonts.robotoMono(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Odoo ERP Sync Button
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.ink,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            icon: _isSyncing
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync_rounded,
                    size: 16, color: AppColors.primary),
            label: Text(
              _isSyncing ? 'Menyinkronkan...' : 'SYNC ODOO',
              style: GoogleFonts.robotoMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.8,
              ),
            ),
            onPressed: _isSyncing ? null : _triggerOdooSync,
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profil()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.surfaceMuted,
                backgroundImage: AssetImage(user.avatarAsset),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Personnel Welcome & Hub Status
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(
                          Icons.warehouse_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gudang Kebonsari Hub • Distribusi Malang',
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Personel Aktif: ${user.fullName} (${user.roleLabel}) • Sesi Terverifikasi Odoo ERP',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: AppColors.inkMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isDesktop)
                        StatusStampBadge.approved(label: 'SISTEM NORMAL'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Operational Ledger Strip (4 Metrics in unified tabular layout)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: isDesktop
                      ? Row(
                          children: [
                            Expanded(
                              child: _buildMetricCell(
                                label: 'Permintaan Masuk',
                                count: totalRequests.toString(),
                                code: 'REQ-IN',
                                icon: Icons.description_rounded,
                                color: AppColors.primary,
                              ),
                            ),
                            const _VerticalDivider(),
                            Expanded(
                              child: _buildMetricCell(
                                label: 'Sedang Dikirim',
                                count: inTransitCount.toString(),
                                code: 'DSP-ACT',
                                icon: Icons.local_shipping_rounded,
                                color: AppColors.amberText,
                              ),
                            ),
                            const _VerticalDivider(),
                            Expanded(
                              child: _buildMetricCell(
                                label: 'Selesai Terkirim',
                                count: deliveredCount.toString(),
                                code: 'DSP-DONE',
                                icon: Icons.check_circle_rounded,
                                color: AppColors.statusGreenAction,
                              ),
                            ),
                            const _VerticalDivider(),
                            Expanded(
                              child: _buildMetricCell(
                                label: 'Skor Optimal SAW',
                                count: bestScore,
                                code: 'OPT-SAW',
                                icon: Icons.tune_rounded,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricCell(
                                    label: 'Permintaan',
                                    count: totalRequests.toString(),
                                    code: 'REQ',
                                    icon: Icons.description_rounded,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const _VerticalDivider(),
                                Expanded(
                                  child: _buildMetricCell(
                                    label: 'Proses Kirim',
                                    count: inTransitCount.toString(),
                                    code: 'IN-TRANSIT',
                                    icon: Icons.local_shipping_rounded,
                                    color: AppColors.amberText,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: AppColors.border, height: 1),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricCell(
                                    label: 'Terkirim',
                                    count: deliveredCount.toString(),
                                    code: 'DONE',
                                    icon: Icons.check_circle_rounded,
                                    color: AppColors.statusGreenAction,
                                  ),
                                ),
                                const _VerticalDivider(),
                                Expanded(
                                  child: _buildMetricCell(
                                    label: 'Skor SAW',
                                    count: bestScore,
                                    code: 'SAW',
                                    icon: Icons.tune_rounded,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 20),

                // Responsive Section: Product & Agent Cards (Side-by-Side on Web, Stacked on Mobile)
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildProductLedgerCard(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAgentLedgerCard(),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildProductLedgerCard(),
                      const SizedBox(height: 16),
                      _buildAgentLedgerCard(),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCell({
    required String label,
    required String count,
    required String code,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                code,
                style: GoogleFonts.robotoMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.inkMuted,
                  letterSpacing: 0.8,
                ),
              ),
              Icon(icon, size: 14, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: GoogleFonts.montserrat(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductLedgerCard() {
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
                    const Icon(Icons.star_rounded,
                        size: 16, color: AppColors.amberStamp),
                    const SizedBox(width: 8),
                    Text(
                      'PRODUK TERLARIS BULAN INI',
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    'SKU-DO-24',
                    style: GoogleFonts.robotoMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Container
                Container(
                  width: 110,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      'assets/images/DjavaOcha.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Product Data Table
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Djava Ocha',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        'Kategori: Minuman Teh Herbal SKT',
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          color: AppColors.inkMuted,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const DashedRule(),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Expanded(
                            child: LedgerDataCell(
                              label: 'Total Terjual',
                              value: '1.420',
                              unit: 'Pack',
                            ),
                          ),
                          Expanded(
                            child: LedgerDataCell(
                              label: 'Rilis Produk',
                              value: '30-03-2023',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Expanded(
                            child: LedgerDataCell(
                              label: 'Kadar Tar',
                              value: '24.8',
                              unit: 'Mg',
                            ),
                          ),
                          Expanded(
                            child: LedgerDataCell(
                              label: 'Nikotin',
                              value: '1.3',
                              unit: 'Mg',
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
        ],
      ),
    );
  }

  Widget _buildAgentLedgerCard() {
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
                    const Icon(Icons.workspace_premium,
                        size: 16, color: AppColors.amberText),
                    const SizedBox(width: 8),
                    Text(
                      'AGEN DISTRIBUSI TERBAIK',
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    'AGEN-MLG-01',
                    style: GoogleFonts.robotoMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Agent Logo / Image
                Container(
                  width: 110,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      'assets/images/AlfaDuro.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Agent Specs
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Toko Alfa Duro',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        'Jl. Trunojoyo No. 212, Malang',
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          color: AppColors.inkMuted,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const DashedRule(),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Expanded(
                            child: LedgerDataCell(
                              label: 'Akumulasi Order',
                              value: 'Rp 6.000.000',
                            ),
                          ),
                          Expanded(
                            child: LedgerDataCell(
                              label: 'Terdaftar Sejak',
                              value: '30-03-2020',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Expanded(
                            child: LedgerDataCell(
                              label: 'Item Favorit',
                              value: 'Djava Ocha',
                            ),
                          ),
                          Expanded(
                            child: LedgerDataCell(
                              label: 'Status Agen',
                              value: 'Prioritas A',
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
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 70,
      color: AppColors.border,
    );
  }
}

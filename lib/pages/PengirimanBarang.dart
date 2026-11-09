import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/models/route_models.dart';
import 'package:route_wise/services/app_state.dart';
import 'package:route_wise/theme/app_theme.dart';

class PengirimanBarang extends StatefulWidget {
  const PengirimanBarang({super.key});

  @override
  State<PengirimanBarang> createState() => _PengirimanBarangState();
}

class _PengirimanBarangState extends State<PengirimanBarang> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  DeliveryStatus? _statusFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final allDeliveries = appState.deliveries;

    final inTransitCount = allDeliveries
        .where((d) => d.status == DeliveryStatus.onProgress)
        .length;
    final deliveredCount = allDeliveries
        .where((d) => d.status == DeliveryStatus.success)
        .length;

    final deliveries = allDeliveries.where((item) {
      final matchesStatus =
          _statusFilter == null || item.status == _statusFilter;
      final q = _searchQuery.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          item.product.toLowerCase().contains(q) ||
          item.driverName.toLowerCase().contains(q) ||
          item.destination.toLowerCase().contains(q);
      return matchesStatus && matchesQuery;
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
          'MANIFEST SURAT JALAN PENGIRIMAN',
          style: GoogleFonts.robotoMono(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            children: [
              // Search & Segmented Filter Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    bottom: BorderSide(color: AppColors.border, width: 1),
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Cari nomor manifest, driver, atau tujuan...',
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: AppColors.inkLight,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
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
                    const SizedBox(height: 12),

                    // Filter Chips
                    Row(
                      children: [
                        _buildFilterChip(
                          label: 'SEMUA SURAT JALAN',
                          count: allDeliveries.length,
                          isSelected: _statusFilter == null,
                          onTap: () => setState(() => _statusFilter = null),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: 'DALAM PENGIRIMAN',
                          count: inTransitCount,
                          isSelected: _statusFilter == DeliveryStatus.onProgress,
                          onTap: () => setState(
                            () => _statusFilter = DeliveryStatus.onProgress,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: 'SELESAI TERKIRIM',
                          count: deliveredCount,
                          isSelected: _statusFilter == DeliveryStatus.success,
                          onTap: () => setState(
                            () => _statusFilter = DeliveryStatus.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Deliveries List
              Expanded(
                child: deliveries.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada data surat jalan yang cocok dengan filter.',
                          style: GoogleFonts.montserrat(
                            color: AppColors.inkMuted,
                            fontSize: 13,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: deliveries.length,
                        itemBuilder: (context, index) {
                          return _buildDeliveryManifestCard(
                            context,
                            deliveries[index],
                            index,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.ink : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? AppColors.ink : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.robotoMono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : AppColors.ink,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                count.toString(),
                style: GoogleFonts.robotoMono(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : AppColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryManifestCard(
    BuildContext context,
    DeliveryOrder delivery,
    int index,
  ) {
    final appState = AppStateScope.of(context);
    final isDelivered = delivery.status == DeliveryStatus.success;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Manifest Header Strip
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
                    Text(
                      '#SJ-MLG-00${index + 1}',
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Tgl Kirim: ${delivery.orderDate}',
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
                isDelivered
                    ? StatusStampBadge.delivered()
                    : StatusStampBadge.inTransit(),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            delivery.destination,
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.idBadge,
                                size: 12,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Driver: ${delivery.driverName}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.inkMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: LedgerDataCell(
                        label: 'VOLUME',
                        value: '${delivery.quantityPacks}',
                        unit: 'Pack',
                        crossAxisAlignment: CrossAxisAlignment.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const DashedRule(),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PRODUK: ${delivery.product.toUpperCase()}',
                          style: GoogleFonts.robotoMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.inkMuted,
                          ),
                        ),
                        Text(
                          'Estimasi Tiba: ${delivery.expectedDate}',
                          style: GoogleFonts.robotoMono(
                            fontSize: 10,
                            color: AppColors.inkLight,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDelivered
                            ? AppColors.surfaceMuted
                            : AppColors.statusGreenAction,
                        foregroundColor:
                            isDelivered ? AppColors.ink : Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(
                            color: isDelivered
                                ? AppColors.border
                                : AppColors.statusGreenBorder,
                          ),
                        ),
                      ),
                      icon: Icon(
                        isDelivered
                            ? Icons.replay_rounded
                            : Icons.check_circle_outline_rounded,
                        size: 15,
                      ),
                      label: Text(
                        isDelivered
                            ? 'KEMBALIKAN KE PROSES'
                            : 'TANDAI SELESAI',
                        style: GoogleFonts.robotoMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () {
                        appState.toggleDeliveryStatus(delivery.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.ink,
                            content: Text(
                              'Status pengiriman ${delivery.destination} diperbarui.',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

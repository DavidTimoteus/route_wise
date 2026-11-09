import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/models/route_models.dart';
import 'package:route_wise/services/app_state.dart';
import 'package:route_wise/theme/app_theme.dart';

class ListPermintaan extends StatefulWidget {
  const ListPermintaan({super.key});

  @override
  State<ListPermintaan> createState() => _ListPermintaanState();
}

class _ListPermintaanState extends State<ListPermintaan> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  RequestStatus? _statusFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddRequestDialog() {
    final formKey = GlobalKey<FormState>();
    final agentController = TextEditingController();
    final productController = TextEditingController(text: 'Djava Ocha');
    final quantityController = TextEditingController();
    final destinationController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.border),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                'Catat Permintaan Baru',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: agentController,
                    decoration: const InputDecoration(
                      labelText: 'NAMA TOKO / AGEN',
                      hintText: 'Contoh: Toko Barokah 2',
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: productController.text,
                    decoration: const InputDecoration(labelText: 'PRODUK'),
                    items: const [
                      DropdownMenuItem(
                        value: 'Djava Ocha',
                        child: Text('Djava Ocha (Teh Herbal)'),
                      ),
                      DropdownMenuItem(
                        value: 'Djava Traditional',
                        child: Text('Djava Traditional (Rempah)'),
                      ),
                      DropdownMenuItem(
                        value: 'Alfa Duro',
                        child: Text('Alfa Duro (Minuman Segar)'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) productController.text = val;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'JUMLAH PERMINTAAN (PACK)',
                      hintText: 'Contoh: 150',
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: destinationController,
                    decoration: const InputDecoration(
                      labelText: 'ALAMAT TUJUAN',
                      hintText: 'Contoh: Jl. Soekarno Hatta No. 45',
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                'Batal',
                style: GoogleFonts.montserrat(color: AppColors.inkMuted),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final qty = int.tryParse(quantityController.text) ?? 100;
                  AppStateScope.of(context).addMarketRequest(
                    agentName: agentController.text.trim(),
                    product: productController.text,
                    quantityPacks: qty,
                    destination: destinationController.text.trim(),
                  );
                  Navigator.pop(dialogCtx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Permintaan baru berhasil ditambahkan ke daftar.'),
                    ),
                  );
                }
              },
              child: const Text('Simpan Permintaan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final allRequests = appState.requests;

    final pendingCount =
        allRequests.where((r) => r.status == RequestStatus.pending).length;
    final approvedCount =
        allRequests.where((r) => r.status == RequestStatus.approved).length;
    final rejectedCount =
        allRequests.where((r) => r.status == RequestStatus.rejected).length;

    final filteredRequests = allRequests.where((item) {
      final matchesStatus =
          _statusFilter == null || item.status == _statusFilter;
      final q = _searchQuery.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          item.product.toLowerCase().contains(q) ||
          item.destination.toLowerCase().contains(q) ||
          item.agentName.toLowerCase().contains(q);
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
          'DAFTAR PERMINTAAN PASAR',
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
              icon: const Icon(Icons.add_rounded, size: 16),
              label: Text(
                'TAMBAH PERMINTAAN',
                style: GoogleFonts.robotoMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              onPressed: _showAddRequestDialog,
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            children: [
              // Search & Filter Bar
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
                        hintText: 'Cari toko, produk, atau alamat tujuan...',
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

                    // Segmented Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            label: 'SEMUA',
                            count: allRequests.length,
                            isSelected: _statusFilter == null,
                            onTap: () => setState(() => _statusFilter = null),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'MENUNGGU',
                            count: pendingCount,
                            isSelected: _statusFilter == RequestStatus.pending,
                            onTap: () => setState(
                              () => _statusFilter = RequestStatus.pending,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'DISETUJUI',
                            count: approvedCount,
                            isSelected: _statusFilter == RequestStatus.approved,
                            onTap: () => setState(
                              () => _statusFilter = RequestStatus.approved,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'DITOLAK',
                            count: rejectedCount,
                            isSelected: _statusFilter == RequestStatus.rejected,
                            onTap: () => setState(
                              () => _statusFilter = RequestStatus.rejected,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Request Slips List
              Expanded(
                child: filteredRequests.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada tiket permintaan yang sesuai dengan kriteria.',
                          style: GoogleFonts.montserrat(
                            color: AppColors.inkMuted,
                            fontSize: 13,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredRequests.length,
                        itemBuilder: (context, index) {
                          return _buildRequestSlipCard(
                            context,
                            filteredRequests[index],
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

  Widget _buildRequestSlipCard(
    BuildContext context,
    MarketRequest req,
    int index,
  ) {
    final appState = AppStateScope.of(context);
    final isApproved = req.status == RequestStatus.approved;
    final isRejected = req.status == RequestStatus.rejected;

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
          // Slip Header
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
                      '#REQ-MLG-00${index + 1}',
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      req.orderDate,
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
                if (isApproved)
                  StatusStampBadge.approved()
                else if (isRejected)
                  StatusStampBadge.rejected()
                else
                  StatusStampBadge.pending(),
              ],
            ),
          ),

          // Slip Details
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
                            req.agentName,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 13,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  req.destination,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: AppColors.inkMuted,
                                  ),
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
                        label: 'MUATAN',
                        value: '${req.quantityPacks}',
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
                    Text(
                      'ITEM: ${req.product.toUpperCase()}',
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.inkMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.statusRedText,
                            side: const BorderSide(
                              color: AppColors.statusRedBorder,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () {
                            appState.updateRequestStatus(
                              req.id,
                              RequestStatus.rejected,
                            );
                          },
                          child: Text(
                            'TOLAK',
                            style: GoogleFonts.robotoMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.statusGreenAction,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () {
                            appState.updateRequestStatus(
                              req.id,
                              RequestStatus.approved,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.statusGreenAction,
                                content: Text(
                                  'Permintaan ${req.agentName} disetujui.',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'SETUJUI',
                            style: GoogleFonts.robotoMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
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
        ],
      ),
    );
  }
}

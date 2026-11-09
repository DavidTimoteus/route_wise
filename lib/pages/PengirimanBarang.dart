import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/Components/text_field.dart';
import 'package:route_wise/models/route_models.dart';
import 'package:route_wise/services/app_state.dart';

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

  void _cycleFilter() {
    setState(() {
      if (_statusFilter == null) {
        _statusFilter = DeliveryStatus.onProgress;
      } else if (_statusFilter == DeliveryStatus.onProgress) {
        _statusFilter = DeliveryStatus.success;
      } else {
        _statusFilter = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final deliveries = appState.deliveries.where((item) {
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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            FontAwesomeIcons.circleChevronLeft,
            color: Color(0xFFE45F2B),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _cycleFilter,
            tooltip: 'Filter Status Pengiriman',
            icon: const Icon(
              FontAwesomeIcons.filter,
              color: Color(0xFFE45F2B),
            ),
          ),
        ],
        title: Text(
          'Pengiriman Barang',
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              inputFile(
                label: '',
                icon: FontAwesomeIcons.magnifyingGlass,
                teks: 'Search...',
                controller: _searchController,
                filled: true,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'List By Date',
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFFE45F2B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_statusFilter != null)
                    Chip(
                      label: Text(
                        _statusFilter!.label,
                        style: GoogleFonts.montserrat(fontSize: 11),
                      ),
                      onDeleted: () {
                        setState(() {
                          _statusFilter = null;
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: 5),
              ...deliveries
                  .map((delivery) => _buildDeliveryCard(context, delivery)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryCard(BuildContext context, DeliveryOrder delivery) {
    final isSuccess = delivery.status == DeliveryStatus.success;
    final bgColor = isSuccess
        ? const Color.fromRGBO(210, 255, 215, 1)
        : const Color.fromRGBO(255, 252, 225, 1);

    return GestureDetector(
      onTap: () {
        AppStateScope.of(context).toggleDeliveryStatus(delivery.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  delivery.status.label,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Icon(Icons.sync, size: 16, color: Colors.black54),
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
                  child: _buildFieldColumn('Product :', delivery.product),
                ),
                Expanded(
                  child: _buildFieldColumn('Drive Name :', delivery.driverName),
                ),
                Expanded(
                  child: _buildFieldColumn('Order Date :', delivery.orderDate),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildFieldColumn(
                    'Request :',
                    '${delivery.quantityPacks} Pack',
                  ),
                ),
                Expanded(
                  child: _buildFieldColumn(
                    'Destination :',
                    delivery.destination,
                  ),
                ),
                Expanded(
                  child: _buildFieldColumn(
                    'Expected Date :',
                    delivery.expectedDate,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldColumn(String label, String value) {
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
}

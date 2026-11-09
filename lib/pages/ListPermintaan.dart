import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/Components/text_field.dart';
import 'package:route_wise/models/route_models.dart';
import 'package:route_wise/services/app_state.dart';

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

  void _cycleFilter() {
    setState(() {
      if (_statusFilter == null) {
        _statusFilter = RequestStatus.pending;
      } else if (_statusFilter == RequestStatus.pending) {
        _statusFilter = RequestStatus.approved;
      } else if (_statusFilter == RequestStatus.approved) {
        _statusFilter = RequestStatus.rejected;
      } else {
        _statusFilter = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final filteredRequests = appState.requests.where((item) {
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
            tooltip: 'Filter Status',
            icon: const Icon(
              FontAwesomeIcons.filter,
              color: Color(0xFFE45F2B),
            ),
          ),
        ],
        title: Text(
          'List Permintaan',
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
                        _statusFilter!.name.toUpperCase(),
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
              if (filteredRequests.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    'Tidak ada permintaan yang sesuai.',
                    style: GoogleFonts.montserrat(color: Colors.grey),
                  ),
                ),
              ...filteredRequests.map((req) => _buildRequestCard(context, req)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, MarketRequest req) {
    final appState = AppStateScope.of(context);
    Color bgColor = const Color.fromRGBO(255, 252, 225, 1);
    if (req.status == RequestStatus.approved) {
      bgColor = const Color.fromRGBO(210, 255, 215, 1);
    } else if (req.status == RequestStatus.rejected) {
      bgColor = const Color.fromRGBO(255, 225, 225, 1);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product :',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            req.product,
                            style: GoogleFonts.montserrat(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Date :',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            req.orderDate,
                            style: GoogleFonts.montserrat(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Request :',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${req.quantityPacks} Pack',
                            style: GoogleFonts.montserrat(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Destination :',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            req.destination,
                            style: GoogleFonts.montserrat(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              InkWell(
                onTap: () {
                  appState.updateRequestStatus(
                    req.id,
                    RequestStatus.approved,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Permintaan ${req.product} disetujui dan masuk jadwal pengiriman.',
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    width: 35,
                    height: 35,
                    color: const Color(0xFF198754),
                    child: const Center(
                      child: Icon(
                        FontAwesomeIcons.circleCheck,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  appState.updateRequestStatus(
                    req.id,
                    RequestStatus.rejected,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Permintaan ${req.product} ditolak.'),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    width: 35,
                    height: 35,
                    color: const Color(0xFFDC3545),
                    child: const Center(
                      child: Icon(
                        FontAwesomeIcons.circleXmark,
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
    );
  }
}

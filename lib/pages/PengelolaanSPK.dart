import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/Components/text_field.dart';
import 'package:route_wise/services/app_state.dart';

class PengelolaanSPK extends StatefulWidget {
  const PengelolaanSPK({super.key});

  @override
  State<PengelolaanSPK> createState() => _PengelolaanSPKState();
}

class _PengelolaanSPKState extends State<PengelolaanSPK> {
  String? selectedvalue;
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _itemsController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  bool _showRanking = true;

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
      selectedvalue = storeName;
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
    final storeName = selectedvalue;
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
        content: Text('Data SPK untuk $storeName berhasil disimpan.'),
      ),
    );
  }

  void _handleFinishCalculation() {
    AppStateScope.of(context).recalculateSpkRanking();
    setState(() {
      _showRanking = true;
    });
    final top = AppStateScope.of(context).spkAlternatives;
    if (top.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Rekomendasi utama SAW: ${top.first.storeName} (Skor: ${top.first.sawScore})',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final alternatives = AppStateScope.of(context).spkAlternatives;

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
              FontAwesomeIcons.rightFromBracket,
              color: Color.fromARGB(255, 255, 94, 0),
            ),
          ),
        ],
        title: const Text(
          'Pengelolaan SPK',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 94, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Alternatif',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: selectedvalue == null
                            ? Colors.black
                            : const Color.fromARGB(255, 255, 203, 59),
                      ),
                    ),
                    child: DropdownButton<String?>(
                      value: selectedvalue,
                      hint: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Pilih Toko Tujuan'),
                      ),
                      onChanged: _onSelectStore,
                      underline: const SizedBox(),
                      isExpanded: true,
                      items: _storeOptions
                          .map<DropdownMenuItem<String>>(
                            (store) => DropdownMenuItem(
                              value: store,
                              child: Row(
                                children: [
                                  const SizedBox(width: 7),
                                  Icon(
                                    FontAwesomeIcons.shop,
                                    color: selectedvalue == null
                                        ? Colors.black
                                        : const Color.fromARGB(
                                            255,
                                            255,
                                            203,
                                            59,
                                          ),
                                  ),
                                  const SizedBox(width: 15),
                                  Text(store),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Divider(
                      thickness: 2,
                      color: Color(0xFFF6C445),
                    ),
                  ),
                  inputFile(
                    label: 'Jarak Tempuh (Km)',
                    teks: 'Contoh: 2.5',
                    icon: FontAwesomeIcons.road,
                    controller: _distanceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                  inputFile(
                    label: 'Banyak Barang (Pack)',
                    teks: 'Contoh: 200',
                    icon: FontAwesomeIcons.cube,
                    controller: _itemsController,
                    keyboardType: TextInputType.number,
                  ),
                  inputFile(
                    label: 'Estimasi Biaya (Rp)',
                    teks: 'Contoh: 45000',
                    icon: FontAwesomeIcons.coins,
                    controller: _costController,
                    keyboardType: TextInputType.number,
                  ),
                  inputFile(
                    label: 'Waktu Tempuh (Menit)',
                    teks: 'Contoh: 15',
                    icon: FontAwesomeIcons.hourglassHalf,
                    controller: _timeController,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 2,
                color: Color(0xFFF6C445),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                width: 400,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE45F2B),
                  ),
                  onPressed: _handleAddAlternative,
                  child: Text(
                    'ADD',
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: SizedBox(
                width: 400,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA0E548),
                  ),
                  onPressed: _handleFinishCalculation,
                  child: Text(
                    'FINISH',
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            if (_showRanking && alternatives.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hasil Perangkingan SPK (Metode SAW)',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFFE45F2B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...alternatives.asMap().entries.map((entry) {
                      final rank = entry.key + 1;
                      final item = entry.value;
                      return Card(
                        color: rank == 1
                            ? const Color.fromRGBO(210, 255, 215, 1)
                            : Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFE45F2B),
                            child: Text(
                              '#$rank',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            item.storeName,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Jarak: ${item.distanceKm} Km | Barang: ${item.itemCount} | Waktu: ${item.travelTimeMinutes.toStringAsFixed(0)} mnt',
                            style: GoogleFonts.montserrat(fontSize: 12),
                          ),
                          trailing: Text(
                            item.sawScore.toStringAsFixed(3),
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE45F2B),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/laporan_stok_service.dart';

// ignore: use_key_in_widget_constructors
class LaporanStokPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _LaporanStokPageState createState() => _LaporanStokPageState();
}

class _LaporanStokPageState extends State<LaporanStokPage> {
  List<dynamic> laporan = [];
  String selectedFilter = 'semua';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData({String? tipe, String? tanggal, String? bulan, String? tahun}) async {
    final service = LaporanStokService();
    try {
      final data = await service.getLaporanStok(
        tipe: tipe,
        tanggal: tanggal,
        bulan: bulan,
        tahun: tahun,
      );
      setState(() {
        laporan = data;
      });
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laporan Stok"),
        actions: [
          DropdownButton<String>(
            value: selectedFilter,
            items: [
              DropdownMenuItem(value: "semua", child: Text("Semua")),
              DropdownMenuItem(value: "harian", child: Text("Harian")),
              DropdownMenuItem(value: "bulanan", child: Text("Bulanan")),
              DropdownMenuItem(value: "tahunan", child: Text("Tahunan")),
            ],
            onChanged: (value) {
              setState(() {
                selectedFilter = value!;
              });

              if (selectedFilter == "semua") {
                loadData();
              } else if (selectedFilter == "harian") {
                loadData(tipe: "harian", tanggal: "2025-09-16"); // bisa pakai DatePicker
              } else if (selectedFilter == "bulanan") {
                loadData(tipe: "bulanan", bulan: "9", tahun: "2025");
              } else if (selectedFilter == "tahunan") {
                loadData(tipe: "tahunan", tahun: "2025");
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: laporan.length,
        itemBuilder: (context, index) {
          final item = laporan[index];
          return ListTile(
            title: Text(item['nama_barang'] ?? ''),
            subtitle: Text("Jumlah: ${item['jumlah']} | Tipe: ${item['tipe']}"),
          );
        },
      ),
    );
  }
}

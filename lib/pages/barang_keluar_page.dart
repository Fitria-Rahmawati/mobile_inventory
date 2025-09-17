import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/barang_keluar_service.dart';

class BarangKeluarPage extends StatefulWidget {
  // ignore: use_super_parameters
  const BarangKeluarPage({Key? key}) : super(key: key);

  @override
  State<BarangKeluarPage> createState() => _BarangKeluarPageState();
}

class _BarangKeluarPageState extends State<BarangKeluarPage> {
  late Future<List<dynamic>> _barangKeluarFuture;

  @override
  void initState() {
    super.initState();
    _barangKeluarFuture = BarangKeluarService().getBarangKeluar();
  }

  Future<void> _refreshData() async {
    setState(() {
      _barangKeluarFuture = BarangKeluarService().getBarangKeluar();
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Barang Keluar"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _barangKeluarFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Terjadi error: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Data barang keluar kosong"));
          }

          final barangKeluarList = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
              itemCount: barangKeluarList.length,
              itemBuilder: (context, index) {
                final bk = barangKeluarList[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      "Kode: ${bk['kode_keluar'] ?? '-'}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tanggal: ${bk['tanggal'] ?? '-'}"),
                        Text("Penerima: ${bk['tujuan'] ?? '-'}"),
                        const SizedBox(height: 4),
                        if (bk['detail_keluar'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: (bk['detail_keluar'] as List)
                                .map((detail) => Text(
                                    "- ${detail['kode_barang']} | ${detail['nama_barang']} (${detail['jumlah']} x Rp${detail['harga']})"))
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

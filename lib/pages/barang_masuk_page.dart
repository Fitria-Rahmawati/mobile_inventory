import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/barang_masuk_service.dart';

class BarangMasukPage extends StatefulWidget {
  // ignore: use_super_parameters
  const BarangMasukPage({Key? key}) : super(key: key);

  @override
  State<BarangMasukPage> createState() => _BarangMasukPageState();
}

class _BarangMasukPageState extends State<BarangMasukPage> {
  late Future<List<dynamic>> _barangMasukFuture;

  @override
  void initState() {
    super.initState();
    _barangMasukFuture = BarangMasukService().getBarangMasuk();
  }

  Future<void> _refreshData() async {
    setState(() {
      _barangMasukFuture = BarangMasukService().getBarangMasuk();
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
        title: const Text("Barang Masuk"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _barangMasukFuture,
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
            return const Center(child: Text("Data barang masuk kosong"));
          }

          final barangMasukList = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
              itemCount: barangMasukList.length,
              itemBuilder: (context, index) {
                final bm = barangMasukList[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      "Kode: ${bm['kode_masuk'] ?? '-'}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tanggal: ${bm['tanggal'] ?? '-'}"),
                        Text("Vendor: ${bm['nama_vendor'] ?? '-'}"),
                        const SizedBox(height: 4),
                        if (bm['detail_masuk'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: (bm['detail_masuk'] as List)
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

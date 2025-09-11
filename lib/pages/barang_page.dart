import 'package:flutter/material.dart';
import '../services/barang_service.dart';
import '../models/barang.dart';

class BarangPage extends StatefulWidget {
  final String token;
  const BarangPage({super.key, required this.token});

  @override
  State<BarangPage> createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  late BarangService _barangService;
  List<Barang> _barangList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _barangService = BarangService(widget.token);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _barangService.getBarangList();
      setState(() {
        _barangList = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Barang")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.builder(
                itemCount: _barangList.length,
                itemBuilder: (context, index) {
                  final barang = _barangList[index];
                  return ListTile(
                    title: Text(barang.nama),
                    subtitle: Text("Kode: ${barang.kode} | Stok: ${barang.stok}"),
                  );
                },
              ),
            ),
    );
  }
}

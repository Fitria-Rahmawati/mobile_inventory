import 'package:flutter/material.dart';
import '../services/rak_service.dart';
import '../pages/sub_rak_page.dart';

class RakPage extends StatefulWidget {
  const RakPage({super.key});

  @override
  State<RakPage> createState() => _RakPageState();
}

class _RakPageState extends State<RakPage> {
  List<dynamic> rakList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRak();
  }

  Future<void> fetchRak() async {
    try {
      final data = await RakService.getRak();
      setState(() {
        rakList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        rakList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Rak")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : rakList.isEmpty
              ? const Center(child: Text("Tidak ada data rak"))
              : ListView.builder(
                  itemCount: rakList.length,
                  itemBuilder: (context, index) {
                    final rak = rakList[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.storage),
                        title: Text(rak['nama_rak'] ?? 'Tanpa Nama'),
                        subtitle: Text(rak['keterangan'] ?? ''),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SubRakPage(
                                rakId: int.tryParse(rak['id_rak'].toString()) ?? 0, // ✅ aman
                                rakName: rak['nama_rak'] ?? '',
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

import 'package:flutter/material.dart';
import '../services/rak_service.dart';

class SubRakPage extends StatefulWidget {
  final int rakId;
  final String rakName;

  const SubRakPage({super.key, required this.rakId, required this.rakName});

  @override
  State<SubRakPage> createState() => _SubRakPageState();
}

class _SubRakPageState extends State<SubRakPage> {
  List<dynamic> subRakList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSubRak();
  }

  Future<void> fetchSubRak() async {
    try {
      final data = await RakService.getSubRak(widget.rakId);
      setState(() {
        subRakList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        subRakList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sub Rak - ${widget.rakName}")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : subRakList.isEmpty
              ? const Center(child: Text("Tidak ada data sub rak"))
              : ListView.builder(
                  itemCount: subRakList.length,
                  itemBuilder: (context, index) {
                    final subRak = subRakList[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.view_list),
                        title: Text(subRak['nama_sub_rak'] ?? 'Tanpa Nama'),
                        subtitle: Text(subRak['keterangan'] ?? ''),
                      ),
                    );
                  },
                ),
    );
  }
}

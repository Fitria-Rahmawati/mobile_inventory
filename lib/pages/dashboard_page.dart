import 'package:flutter/material.dart';
import 'barang_page.dart';

class DashboardPage extends StatelessWidget {
  final String token;
  const DashboardPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 👉 Arahkan ke BarangPage dengan token
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BarangPage(token: token),
              ),
            );
          },
          child: const Text("Lihat Data Barang"),
        ),
      ),
    );
  }
}

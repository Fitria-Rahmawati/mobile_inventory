import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'rak_page.dart';
import 'barang_masuk_page.dart';
import 'barang_keluar_page.dart';
import 'barang_page.dart';
import 'laporan_stok_page.dart';
import 'login_page.dart'; // buat redirect ke login

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? dashboardData;
  bool isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    loadTokenAndFetch();
  }

  Future<void> loadTokenAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token'); // ambil token login
    if (token != null) {
      fetchDashboard();
    } else {
      setState(() {
        isLoading = false;
        dashboardData = {"error": "Token tidak ditemukan, silakan login ulang"};
      });
    }
  }

  Future<void> fetchDashboard() async {
    final url = Uri.parse("http://192.168.2.215:8080/api/dashboard");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        dashboardData = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        dashboardData = {"error": "Gagal load data: ${response.body}"};
        isLoading = false;
      });
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token'); // hapus token

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Inventory Menu",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text("Barang"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BarangPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text("Barang Masuk"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BarangMasukPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text("Barang Keluar"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BarangKeluarPage()),                 
                );
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text("Rak"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RakPage()),
                  );
              },
            ),
           
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text("Laporan Stok"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LaporanStokPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: logout,
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboardData == null
              ? const Center(child: Text("Data kosong"))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (dashboardData!['error'] != null)
                        Text("Error: ${dashboardData!['error']}"),
                      if (dashboardData!['total_barang'] != null) ...[
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.inventory),
                            title: const Text("Total Barang"),
                            trailing: Text("${dashboardData!['total_barang']}"),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.factory),
                            title: const Text("Total Vendor"),
                            trailing: Text("${dashboardData!['total_vendor']}"),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.download),
                            title: const Text("Barang Masuk Bulan Ini"),
                            trailing: Text("${dashboardData!['barang_masuk']}"),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.upload),
                            title: const Text("Barang Keluar Bulan Ini"),
                            trailing: Text("${dashboardData!['barang_keluar']}"),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}

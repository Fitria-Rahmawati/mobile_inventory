import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../pages/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final identityController = TextEditingController();
  final passwordController = TextEditingController();
  String message = "";
  bool isLoading = false;

  void doLogin() async {
    setState(() {
      message = "";
      isLoading = true;
    });

    final authService = AuthService();
    final result = await authService.login(
      identityController.text,
      passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (result['status'] == 200 || result['success'] == true) {
      // ✅ Ambil token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('api_token') ?? '';

      // Login berhasil → ke dashboard dengan token
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(token: token),
        ),
      );
    } else {
      // ❌ Tampilkan pesan error dari API kalau ada
      setState(() {
        message = result['message'] ?? "Login gagal! Cek username & password.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Inventory")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: identityController,
              decoration: const InputDecoration(labelText: "Email / Username"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: doLogin,
                    child: const Text("Login"),
                  ),
            const SizedBox(height: 20),
            Text(message, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

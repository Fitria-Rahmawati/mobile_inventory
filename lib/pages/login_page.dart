import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final identityController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String message = "";

  void doLogin() async {
    setState(() {
      isLoading = true;
      message = "";
    });

    final authService = AuthService();
    final result = await authService.login(
      identityController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (result['success'] == true) {
      // ke dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } else {
      setState(() => message = result['message']);
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

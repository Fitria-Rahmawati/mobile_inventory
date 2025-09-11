import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MobileInventoryApp());
}

class MobileInventoryApp extends StatelessWidget {
  const MobileInventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Inventory',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}

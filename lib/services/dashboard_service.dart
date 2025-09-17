import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class DashboardService {
  static const String baseUrl = "http://192.168.2.215:8080/api";

  Future<Map<String, dynamic>> getDashboardData() async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/dashboard"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal load dashboard: ${response.body}");
    }
  }
}

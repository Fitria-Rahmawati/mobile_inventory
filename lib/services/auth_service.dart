import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://192.168.2.177:8080/api"; // ganti sesuai backend

  /// Login ke API
  Future<Map<String, dynamic>> login(String identity, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "identity": identity,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      // Ambil token dari response (cek field yang benar di API kamu)
      final token = body['data']['token'] ?? body['data']['access_token'];

      if (token == null) {
        return {"success": false, "message": "Token tidak ditemukan di response"};
      }

      // Simpan token ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return {"success": true, "message": "Login berhasil"};
    } else {
      return {
        "success": false,
        "message": "Login gagal: ${response.body}",
      };
    }
  }

  /// Ambil token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Logout (hapus token)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}

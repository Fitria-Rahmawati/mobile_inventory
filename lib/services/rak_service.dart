import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RakService {
  static const String baseUrl = "http://192.168.2.212:8080/api";

  /// Ambil token dari SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Ambil semua rak
  static Future<List<dynamic>> getRak() async {
    final token = await _getToken();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse("$baseUrl/rak"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception("Gagal load rak: ${response.body}");
    }
  }

  /// Ambil sub rak berdasarkan rakId
  static Future<List<dynamic>> getSubRak(int rakId) async {
    final token = await _getToken();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse("$baseUrl/rak/$rakId/sub-rak"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception("Gagal load sub rak: ${response.body}");
    }
  }

  /// Ambil semua sub rak (opsional, kalau pakai route /rak/sub-rak)
  static Future<List<dynamic>> getAllSubRak() async {
    final token = await _getToken();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse("$baseUrl/rak/sub-rak"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception("Gagal load semua sub rak: ${response.body}");
    }
  }
}

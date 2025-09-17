import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/barang.dart';
import 'auth_service.dart';

class BarangService {
  static const String baseUrl = "http://192.168.2.215:8080/api";

  Future<List<Barang>> getBarangList() async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/barang"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final list = (body['data'] as List)
          .map((e) => Barang.fromJson(e))
          .toList();
      return list;
    } else {
      throw Exception("Gagal load data: ${response.body}");
    }
  }
}

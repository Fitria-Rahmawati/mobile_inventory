import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_token');
  }

  Future<Map<String, dynamic>> getDashboard() async {
    final token = await _getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/dashboard');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return jsonDecode(response.body);
  }
}

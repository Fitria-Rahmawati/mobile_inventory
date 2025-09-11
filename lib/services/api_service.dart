import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  final String? token;

  ApiService({this.token});

  Map<String, String> get headers {
    final base = {"Content-Type": "application/json"};
    if (token != null) {
      return {...base, "Authorization": "Bearer $token"};
    }
    return base;
  }

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/$endpoint");
    final response = await http.get(url, headers: headers);
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/$endpoint");
    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    return _handleResponse(response);
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/$endpoint");
    final response =
        await http.put(url, headers: headers, body: jsonEncode(body));
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/$endpoint");
    final response = await http.delete(url, headers: headers);
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Error ${response.statusCode}: ${response.body}");
    }
  }
}

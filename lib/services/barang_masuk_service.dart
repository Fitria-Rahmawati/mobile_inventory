import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class BarangMasukService {
  Future<List<dynamic>> getBarangMasuk() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final api = ApiService(token: token);
    final response = await api.get("barang-masuk");

    if (response['status'] == 'success') {
      return List<Map<String, dynamic>>.from(response['data']);
    } else {
      throw Exception(response['message'] ?? "Gagal ambil data barang masuk");
    }
  }
}

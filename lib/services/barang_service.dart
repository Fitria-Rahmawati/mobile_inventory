import '../services/api_service.dart';
import '../models/barang.dart';

class BarangService {
  final String token;
  late ApiService _api;

  BarangService(this.token) {
    _api = ApiService(token: token);
  }

  Future<List<Barang>> getBarangList() async {
    final result = await _api.get("barang");

    if (result['status'] == 'success') {
      final List data = result['data'];
      return data.map((e) => Barang.fromJson(e)).toList();
    } else {
      throw Exception(result['message']);
    }
  }
}

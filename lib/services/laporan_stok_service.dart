import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class LaporanStokService {
  final String? token;

  LaporanStokService({this.token});

  Map<String, String> get headers {
    final base = {"Content-Type": "application/json"};
    if (token != null) {
      return {...base, "Authorization": "Bearer $token"};
    }
    return base;
  }

  Future<List<dynamic>> getLaporanStok({String? tipe, String? tanggal, String? bulan, String? tahun}) async {
    Uri url;

    if (tipe != null) {
      // endpoint filter
      final query = {
        "tipe": tipe,
        if (tanggal != null) "tanggal": tanggal,
        if (bulan != null) "bulan": bulan,
        if (tahun != null) "tahun": tahun,
      };
      url = Uri.parse("${ApiConfig.baseUrl}/laporan-stok/filter").replace(queryParameters: query);
    } else {
      // endpoint default (tanpa filter)
      url = Uri.parse("${ApiConfig.baseUrl}/laporan-stok");
    }

    final response = await http.get(url, headers: headers);
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['status'] == 'success') {
      return body['data'];
    } else {
      throw Exception(body['message'] ?? 'Gagal mengambil laporan stok');
    }
  }
}

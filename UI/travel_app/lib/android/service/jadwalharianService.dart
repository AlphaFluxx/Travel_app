import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travel_app/Shared/model/jadwalharian.dart';

class JadwalHarianService {
  final String baseUrl =
      "http://192.168.110.123:3306/pelanggan/booking/jadwalharianScreenjadwal";

  Future<List<JadwalHarian>> fetchJadwalHarian(String asal, String tujuan,
      {String? token}) async {
    final url = Uri.parse('$baseUrl?asal=$asal&tujuan=$tujuan');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      print('Fetching data from: $url with headers: $headers');

      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => JadwalHarian.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load Jadwal Harian. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching Jadwal Harian: $e'); // Log error utama
      rethrow; // Lempar kembali untuk ditangani di UI
    }
  }
}

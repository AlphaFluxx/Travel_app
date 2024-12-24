import 'dart:convert';
import 'package:http/http.dart' as http;

class KursiService {
  final String baseUrl =
      "http://192.168.110.123:3306/pelanggan/booking/getKursi";

  Future<List<Map<String, dynamic>>> fetchKursi(
      int id_kendaraan, String? token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id_kendaraan'),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse
            .map((kursi) => {
                  "nomor_kursi": kursi["nomor_kursi"],
                  "statusKetersediaan": kursi["statusKetersediaan"],
                })
            .toList();
      } else {
        throw Exception(
            "Failed to load kursi data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}

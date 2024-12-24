import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travel_app/Shared/model/jadwalharian.dart';

class JadwalHarianService {
  final String baseUrl =
      "http://192.168.110.123:3306/pelanggan/booking/jadwalharianScreenjadwal";

  final String sisaKursiUrl =
      "http://192.168.110.123:3306/pelanggan/booking/jadwalharianScreenjadwalSisaKursi";

  // Fungsi untuk mengambil data jadwal harian dengan tambahan filter tanggal
  Future<List<JadwalHarian>> fetchJadwalHarian(
      String asal, String tujuan, String tanggal,
      {String? token, int? id_kendaraan}) async {
    // Menambahkan id_kendaraan jika ada
    final url = Uri.parse(
        '$baseUrl?asal=$asal&tujuan=$tujuan&tanggal=$tanggal${id_kendaraan != null ? "&id_kendaraan=$id_kendaraan" : ""}');

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Debugging: Cek data yang diterima

        // Jika ada id_kendaraan, ambil informasi jenis_kendaraan

        return data.map((json) {
          // Debugging: Cek data dalam setiap item
          return JadwalHarian.fromJson(json);
        }).toList();
      } else {
        throw Exception(
            'Failed to load Jadwal Harian. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      // Log error utama
      rethrow; // Lempar kembali untuk ditangani di UI
    }
  }

  // Fungsi untuk mengambil sisa kursi dan id_kendaraan beserta jenis_kendaraan
  Future<Map<String, dynamic>> fetchSisaKursiAndIdKendaraan(int idJadwal,
      {String? token}) async {
    final url = Uri.parse('$sisaKursiUrl/$idJadwal'); // Sesuai backend

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final int sisaKursi = data['sisaKursi'] ?? 0;
        final String jenisKendaraan =
            data['jenis_kendaraan'] ?? 'Tidak Diketahui';
        final int idKendaraan = data['id_kendaraan'] ?? 0;

        return {
          'sisaKursi': sisaKursi,
          'jenisKendaraan': jenisKendaraan,
          'id_kendaraan': idKendaraan
        };
      } else {
        throw Exception('Failed to load Sisa Kursi: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}

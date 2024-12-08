import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KendaraannService {
  static const String baseUrl = 'http://localhost:3306/admin/kendaraan/';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Function to get the token from storage
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token'); // Replace 'token' with your key
  }

  // Mendapatkan semua data Kendaraan
  static Future<List<Map<String, dynamic>>> getAllKendaraan() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null)
          'Authorization': 'Bearer $token', // Add token to headers
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body)['data']);
    } else {
      print('Failed to load Kendaraan data: ${response.body}');
      throw Exception('Failed to load Kendaraan data');
    }
  }

  static Future<void> createKendaraan(Map<String, dynamic> kendaraan) async {
    final token = await getToken();

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(kendaraan),
    );

    if (response.statusCode == 201) {
      print("Kendaraan berhasil ditambahkan.");
      // Log response body untuk memastikan data yang dikirim diterima dengan benar
      print("Response from server: ${response.body}");
    } else {
      print('Failed to create Kendaraan: ${response.body}');
      throw Exception('Failed to create Kendaraan');
    }
  }

  // Memperbarui Kendaraan
  static Future<void> updateKendaraan(
      int id, Map<String, dynamic> kendaraan) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(kendaraan),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update pelanggan');
    }
  }

  // Menghapus Kendaraan
  static Future<void> deleteKendaraan(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete Kendaraan');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KendaraannService {
  static const String baseUrl = 'http://192.168.110.123:3306/admin/kendaraan';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Mendapatkan token dari storage
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // Mendapatkan semua data kendaraan
  static Future<List<Map<String, dynamic>>> getAllKendaraan() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body)['data']);
    } else {
      print('Failed to load Kendaraan data: ${response.body}');
      throw Exception('Failed to load Kendaraan data');
    }
  }

  // Menambahkan kendaraan baru
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
      print("Response from server: ${response.body}");
    } else {
      print('Failed to create Kendaraan: ${response.body}');
      throw Exception('Failed to create Kendaraan');
    }
  }

  // Memperbarui data kendaraan
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
      throw Exception('Failed to update Kendaraan');
    }
  }

  // Menghapus kendaraan
  static Future<void> deleteKendaraan(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Failed to delete Kendaraan');
    }
  }
}

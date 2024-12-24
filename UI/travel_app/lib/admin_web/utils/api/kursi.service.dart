import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KursinService {
  static const String baseUrl = 'http://192.168.110.123:3306/admin/kursi/';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Function to get the token from storage
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token'); // Replace 'token' with your key
  }

  // Mendapatkan semua data kursi
  static Future<List<Map<String, dynamic>>> getAllKursi() async {
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
      print('Failed to load kursi data: ${response.body}');
      throw Exception('Failed to load kursi data');
    }
  }

  // Menambahkan kursi baru
  static Future<void> createKursi(Map<String, dynamic> kursi) async {
    final token = await getToken();

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(kursi),
    );

    if (response.statusCode == 201) {
      print("Kursi berhasil ditambahkan.");
    } else {
      print('Failed to create kursi: ${response.body}');
      throw Exception('Failed to create kursi');
    }
  }

  // Memperbarui kursi
  static Future<void> updateKursi(int id, Map<String, dynamic> kursi) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(kursi),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update pelanggan');
    }
  }

  // Menghapus kursi
  static Future<void> deleteKursi(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete kursi');
    }
  }
}

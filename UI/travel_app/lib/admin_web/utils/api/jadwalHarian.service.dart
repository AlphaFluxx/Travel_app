import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 

class JadwalharianService {
  static const String baseUrl = 'http://localhost:3306/admin/jadwalHarian/';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Function to get the token from storage
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token'); // Replace 'token' with your key
  }

  // Mendapatkan semua data JadwalHarian
  static Future<List<Map<String, dynamic>>> getAllJadwalHarian() async {
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
      print('Failed to load JadwalHarian data: ${response.body}');
      throw Exception('Failed to load JadwalHarian data');
    }
  }

  // Menambahkan JadwalHarian baru
  static Future<void> createJadwalHarian(Map<String, dynamic> jadwalharian) async {
    final token = await getToken();



    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(jadwalharian),
    );

    if (response.statusCode == 201) {
      print("JadwalHarian berhasil ditambahkan.");
    } else {
      print('Failed to create JadwalHarian: ${response.body}');
      throw Exception('Failed to create JadwalHarian');
    }
  }

  // Memperbarui JadwalHarian
  static Future<void> updateJadwalHarian(
      int id, Map<String, dynamic> jadwalharian) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(jadwalharian),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update pelanggan');
    }
  }

  // Menghapus JadwalHarian
  static Future<void> deleteJadwalHarian(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete JadwalHarian');
    }
  }
}

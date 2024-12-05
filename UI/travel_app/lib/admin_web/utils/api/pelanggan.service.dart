import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Example for secure storage

class PelangganService {
  static const String baseUrl = 'http://localhost:3306/admin/pelanggan/';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Function to get the token from storage
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token'); // Replace 'token' with your key
  }

  // Mendapatkan semua data pelanggan
  static Future<List<Map<String, dynamic>>> getAllPelanggan() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token', // Add token to headers
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body)['data']);
    } else {
      print('Failed to load pelanggan data: ${response.body}');
      throw Exception('Failed to load pelanggan data');
    }
  }

  // Menambahkan pelanggan baru
  static Future<void> createPelanggan(Map<String, dynamic> pelanggan) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(pelanggan),
    );

    if (response.statusCode == 201) {
      print("Pelanggan berhasil ditambahkan.");
    } else {
      print('Failed to create pelanggan: ${response.body}');
      throw Exception('Failed to create pelanggan');
    }
  }

  // Memperbarui pelanggan
  static Future<void> updatePelanggan(int id, Map<String, dynamic> pelanggan) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(pelanggan),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update pelanggan');
    }
  }

  // Menghapus pelanggan
  static Future<void> deletePelanggan(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete pelanggan');
    }
  }
}

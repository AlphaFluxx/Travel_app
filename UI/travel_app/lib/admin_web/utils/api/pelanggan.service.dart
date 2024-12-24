import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PelangganService {
  static const String baseUrl = 'http://192.168.110.123:3306/admin/pelanggan/';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Function to get the token from storage
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // Mendapatkan semua data pelanggan
  static Future<List<Map<String, dynamic>>> getAllPelanggan() async {
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
      print('Failed to load pelanggan data: ${response.body}');
      throw Exception('Failed to load pelanggan data');
    }
  }

  // Menambahkan pelanggan baru
  static Future<void> createPelanggan(Map<String, dynamic> pelanggan) async {
    final token = await getToken();

    // Hapus field yang tidak diperlukan
    pelanggan.removeWhere((key, value) => value == null || key == 'id');

    print("Sending create request for pelanggan: $pelanggan");

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(pelanggan),
    );

    print("Response status: ${response.statusCode}"); // Log status kode respons
    print("Response body: ${response.body}"); // Log isi respons dari server

    if (response.statusCode == 201) {
      print("Pelanggan berhasil ditambahkan.");
    } else {
      print('Failed to create pelanggan: ${response.body}');
      throw Exception('Failed to create pelanggan');
    }
  }

  // Memperbarui pelanggan
  static Future<void> updatePelanggan(
      int id, Map<String, dynamic> pelanggan) async {
    final token = await getToken();

    print(
        "Sending update request for pelanggan with ID $id: $pelanggan"); // Log data yang dikirim

    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(pelanggan),
    );

    print("Response status: ${response.statusCode}"); // Log status kode respons
    print("Response body: ${response.body}"); // Log isi respons dari server

    if (response.statusCode != 200) {
      print('Failed to update pelanggan: ${response.body}');
      throw Exception('Failed to update pelanggan');
    } else {
      print("Pelanggan updated successfully.");
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

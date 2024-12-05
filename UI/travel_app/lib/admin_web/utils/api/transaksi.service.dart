import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 

class TransaksiService {
  static const String baseUrl = 'http://localhost:3306/admin/transaksi';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Function to get the token from storage
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token'); // Replace 'token' with your key
  }

  // Mendapatkan semua data Transaksi
  static Future<List<Map<String, dynamic>>> getAllTransaksi() async {
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
      print('Failed to load Transaksi data: ${response.body}');
      throw Exception('Failed to load Transaksi data');
    }
  }

  // Menambahkan Transaksi baru
  static Future<void> createTransaksi(Map<String, dynamic> transaksi) async {
    final token = await getToken();



    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(transaksi),
    );

    if (response.statusCode == 201) {
      print("Transaksi berhasil ditambahkan.");
    } else {
      print('Failed to create Transaksi: ${response.body}');
      throw Exception('Failed to create Transaksi');
    }
  }

  // Memperbarui Transaksi
  static Future<void> updateTransaksi(
      int id, Map<String, dynamic> transaksi) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(transaksi),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update pelanggan');
    }
  }

  // Menghapus Transaksi
  static Future<void> deleteTransaksi(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete Transaksi');
    }
  }
}

// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travel_app/android/widget/CustomBottomNavigationBar.dart';
import '../booking/jadwalScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _asalTerpilih;
  String? _tujuanTerpilih;

  List<String> _asalList = [];
  List<String> _tujuanList = [];

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchAsal();
  }

  Future<void> _fetchAsal() async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      if (token == null) {
        Fluttertoast.showToast(
          msg: "Token tidak ditemukan. Silakan login ulang.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      print("Mengirim request ke endpoint /asal dengan token...");
      final response = await http.get(
        Uri.parse(
            'http://192.168.110.123:3306/pelanggan/booking/jadwalharian/asal'),
        headers: {'Authorization': 'Bearer $token'},
      );
      print("Respons diterima: ${response.statusCode}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _asalList = data.map((e) => e['asal'].toString()).toList();
        });
      } else {
        Fluttertoast.showToast(
          msg: "Gagal memuat data asal",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Terjadi error saat memuat data asal",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _fetchTujuan(String asal) async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      if (token == null) {
        Fluttertoast.showToast(
          msg: "Token tidak ditemukan. Silakan login ulang.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      final response = await http.get(
        Uri.parse(
            'http://192.168.110.123:3306/pelanggan/booking/jadwalharian/tujuan?asal=$asal'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _tujuanList = data.map((e) => e['tujuan'].toString()).toList();
        });
      } else {
        Fluttertoast.showToast(
          msg: "Gagal memuat data tujuan",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Terjadi error saat memuat data tujuan",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121111),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 45.0),
        child: Column(
          children: [
            Material(
              color: const Color(0xFF121111),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Selamat Pagi",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Sarabun',
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: const Color(0xFF1A1B1F),
                    foregroundColor: Colors.white,
                    tooltip: 'Tambah Item',
                    shape: const CircleBorder(),
                    child: ColorFiltered(
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      child: Image.asset('assets/icon/bell-regular-24.png'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: FormPencarianTiket(
                asalList: _asalList,
                tujuanList: _tujuanList,
                fetchTujuan: _fetchTujuan,
                tujuanTerpilih: _tujuanTerpilih,
                onCariTiketPressed: (asal, tujuan) {
                  if (asal != null && tujuan != null) {
                    // Navigasi ke JadwalScreen dengan membawa asal dan tujuan
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Jadwal(asal: asal, tujuan: tujuan),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class FormPencarianTiket extends StatefulWidget {
  final List<String> asalList;
  final List<String> tujuanList;
  final Function fetchTujuan;
  final String? tujuanTerpilih;
  final Function(String?, String?) onCariTiketPressed; 

  FormPencarianTiket({
    required this.asalList,
    required this.tujuanList,
    required this.fetchTujuan,
    required this.tujuanTerpilih,
    required this.onCariTiketPressed, 
  });

  @override
  _FormPencarianTiketState createState() => _FormPencarianTiketState();
}

class _FormPencarianTiketState extends State<FormPencarianTiket> {
  String? _asalTerpilih;
  String? _tujuanTerpilih;

  @override
  void initState() {
    super.initState();
    _tujuanTerpilih = widget.tujuanTerpilih;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDropdownField(
          'Pilih Titik Keberangkatan', 
          'assets/icon/arah_biru.png',
          Colors.blue,
          widget.asalList,
          _asalTerpilih,
          (newValue) {
            setState(() {
              _asalTerpilih = newValue;
              _tujuanTerpilih = null;
              widget.fetchTujuan(newValue!);
            });
          },
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          'Pilih Titik Tujuan',
          'assets/icon/arah_merah.png',
          Colors.red,
          _asalTerpilih == null ? [] : widget.tujuanList,
          _tujuanTerpilih,
          (newValue) {
            setState(() {
              _tujuanTerpilih = newValue;
            });
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_asalTerpilih != null && _tujuanTerpilih != null) {
                widget.onCariTiketPressed(
                    _asalTerpilih, _tujuanTerpilih); 
              } else {
                Fluttertoast.showToast(
                  msg: "Pilih asal dan tujuan terlebih dahulu!",
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10E0ED),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Cari Tiket',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String labelText,
    String iconPath,
    Color iconColor,
    List<String> items,
    String? selectedItem,
    ValueChanged<String?> onChanged,
  ) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: ImageIcon(
          AssetImage(iconPath),
          color: iconColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedItem,
          icon: ImageIcon(
            AssetImage('assets/icon/panah_kanan.png'),
            color: Colors.black,
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

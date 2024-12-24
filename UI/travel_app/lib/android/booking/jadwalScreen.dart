// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:travel_app/android/home/homeScreen.dart';
import '../widget/CustomBottomNavigationBar.dart';
import '/android/booking/SeatSelectionScreen.dart';
import 'package:travel_app/Shared/model/jadwalharian.dart';
import '../service/jadwalharianService.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Jadwal extends StatefulWidget {
  final String asal;
  final String tujuan;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Jadwal({required this.asal, required this.tujuan});

  @override
  _JadwalState createState() => _JadwalState();
}

class _JadwalState extends State<Jadwal> {
  int _selectedIndex = 0;
  int _selectedBoxIndex = -1;

  Future<String?> getIdPelanggan() async {
    try {
      const storage = FlutterSecureStorage();
      String? idPelanggan = await storage.read(key: 'idpelanggan');
      return idPelanggan; 
    } catch (error) {
      return null;
    }
  }

  final ScrollController _scrollController = ScrollController();
  String tanggal = '';
  List<JadwalHarian> jadwalHarianList = [];
  bool isLoading = false;
  Map<int, int> sisaKursiMap = {};

  final JadwalHarianService service = JadwalHarianService();

  Future<void> _loadJadwalHarian() async {
    setState(() {
      isLoading = true;
      jadwalHarianList.clear();
    });
    String? token = await widget.secureStorage.read(key: 'jwt_token');
    if (token == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    try {
      if (tanggal.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      DateTime selectedDate = DateTime.parse(
          "${tanggal.split('-')[2]}-${tanggal.split('-')[1]}-${tanggal.split('-')[0]}");
      String formattedTanggal =
          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

      List<JadwalHarian> jadwal = await service.fetchJadwalHarian(
        widget.asal,
        widget.tujuan,
        formattedTanggal,
        token: token,
      );

      setState(() {
        jadwalHarianList = jadwal;
      });

      // Debugging hasil response
      jadwal.forEach((jadwalItem) {});

      for (var jadwal in jadwalHarianList) {
        _fetchSisaKursi(jadwal.id, token);
      }

      // Periksa apakah jadwal tersedia setelah semua data dimuat
    } catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Map<int, int> idKendaraanMap = {};
  Map<int, String> jenisKendaraanMap =
      {}; // Menyimpan jenis kendaraan per idJadwal

  Future<void> _fetchSisaKursi(int idJadwal, String token) async {
    try {
      final result =
          await service.fetchSisaKursiAndIdKendaraan(idJadwal, token: token);
      setState(() {
        sisaKursiMap[idJadwal] = result['sisaKursi'];
        jenisKendaraanMap[idJadwal] = result['jenisKendaraan'];
        idKendaraanMap[idJadwal] =
            result['id_kendaraan']; // Simpan id_kendaraan
      });
    } catch (e) {}
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDate();
    });
  }

  void _scrollToCurrentDate() {
    DateTime now = DateTime.now();
    double targetPosition = (now.day - 1) * 76.0;
    _scrollController.jumpTo(targetPosition > 0 ? targetPosition - 152.0 : 0);
  }

  String formatTime(String time) {
    List<String> timeParts = time.split(":");
    return "${timeParts[0]}:${timeParts[1]}";
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int currentDay = now.day;
    int currentMonth = now.month;
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    List<JadwalHarian> availableJadwal = jadwalHarianList
        .where((jadwal) =>
            sisaKursiMap[jadwal.id] != null && sisaKursiMap[jadwal.id]! > 0)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121111),
      body: Column(
        children: [
          Material(
            color: const Color(0xFF121111),
            child: Row(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  backgroundColor: const Color(0xFF1A1B1F),
                  foregroundColor: Colors.white,
                  tooltip: 'Back',
                  shape: const CircleBorder(),
                  child: ColorFiltered(
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    child: Image.asset('assets/icon/back.png'),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  widget.asal,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(width: 30),
                ColorFiltered(
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  child: Image.asset('assets/icon/next.png',
                      width: 100, height: 50),
                ),
                Text(
                  widget.tujuan,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 60,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: daysInMonth,
              itemBuilder: (context, index) {
                int day = index + 1;
                bool isPast = day < currentDay;

                return GestureDetector(
                  onTap: isPast
                      ? null
                      : () {
                          setState(() {
                            _selectedBoxIndex = index;
                            tanggal = "$day-${now.month}-${now.year}";
                          });
                          _loadJadwalHarian();
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: _selectedBoxIndex == index
                            ? Colors.cyan
                            : (isPast ? Colors.grey : const Color(0xFF1A1B1F)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$day",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (availableJadwal.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: availableJadwal.length,
                itemBuilder: (context, index) {
                  var jadwal = availableJadwal[index];
                  int? sisaKursi = sisaKursiMap[jadwal.id];

                  return GestureDetector(
                      onTap: () async {
                        String? idPelanggan = await getIdPelanggan();
                        if (idPelanggan != null && idPelanggan.isNotEmpty) {
                          try {
                            int parsedId = int.parse(
                                idPelanggan); // Pastikan parsing berhasil
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeatSelectionScreen(
                                  asal: widget.asal,
                                  tujuan: widget.tujuan,
                                  tanggal: tanggal,
                                  waktu_berangkat: jadwal.waktuBerangkat,
                                  waktu_kedatangan: jadwal.waktuKedatangan,
                                  idJadwal: jadwal.id,
                                  idPelanggan: parsedId,
                                  harga: jadwal.harga,
                                  idKendaraan: idKendaraanMap[jadwal.id] ?? 0,
                                  jenisKendaraan:
                                      jenisKendaraanMap[jadwal.id] ??
                                          'Tidak Diketahui',
                                ),
                              ),
                            );
                          } catch (e) {
                            _showToast(
                                'Id pelanggan tidak valid. Silakan login ulang.');
                          }
                        } else {
                          _showToast(
                              'Id pelanggan tidak ditemukan. Silakan login ulang.');
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1B1F),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Rp ${jadwal.harga}/Kursi",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Text(
                                    sisaKursi != null
                                        ? "Sisa Kursi: $sisaKursi"
                                        : "Memuat sisa kursi...",
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(formatTime(jadwal.waktuBerangkat),
                                          style: const TextStyle(
                                              color: Colors.cyan,
                                              fontSize: 16)),
                                      const Text("3 jam perjalanan",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14)),
                                      Text(formatTime(jadwal.waktuKedatangan),
                                          style: const TextStyle(
                                              color: Colors.cyan,
                                              fontSize: 16)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                decoration: BoxDecoration(),
                                child: Text(
                                  "Jenis Armada: ${jenisKendaraanMap[jadwal.id] ?? 'Tidak Diketahui'}", // Ganti dengan jenis kendaraan yang sesuai
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: 'jwt_token', value: token);
  }

  Jadwal({required this.asal, required this.tujuan});

  @override
  _JadwalState createState() => _JadwalState();
}

class _JadwalState extends State<Jadwal> {
  int _selectedIndex = 0;
  int _selectedBoxIndex = -1;

  final ScrollController _scrollController = ScrollController();
  String tanggal = '';
  int sisaKursi = 14; // Default
  int harga = 45000; // Default
  List<JadwalHarian> jadwalHarianList = [];
  bool isLoading = false; // Indikator loading

  Future<void> _loadJadwalHarian() async {
    setState(() {
      isLoading = true;
    });

    String? token = await widget.secureStorage.read(key: 'jwt_token');
    if (token == null) {
      print('Token tidak ditemukan!');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      JadwalHarianService service = JadwalHarianService();

      print('Memulai request jadwal harian dengan token: $token');
      List<JadwalHarian> jadwal = await service
          .fetchJadwalHarian(widget.asal, widget.tujuan, token: token);

      setState(() {
        jadwalHarianList = jadwal;
      });
    } catch (e) {
      print('Error loading jadwal harian: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDate();
    });
    _loadJadwalHarian(); // Memuat data jadwal harian saat halaman dimuat
  }

  void _scrollToCurrentDate() {
    DateTime now = DateTime.now();
    double targetPosition = (now.day - 1) * 76.0; // Menghitung posisi scroll
    _scrollController.jumpTo(targetPosition > 0 ? targetPosition - 152.0 : 0);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String formatTime(String time) {
    List<String> timeParts = time.split(":");
    return "${timeParts[0]}:${timeParts[1]}";
  }

  String getMonthName(int month) {
    const months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int currentDay = now.day;
    int currentMonth = now.month;
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;

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
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Sarabun', fontSize: 16),
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
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Sarabun', fontSize: 16),
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
                            tanggal =
                                "$day ${getMonthName(currentMonth)} ${now.year}";
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
                              getMonthName(currentMonth),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Sarabun',
                                  fontSize: 12),
                            ),
                            Text(
                              "$day",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Sarabun',
                                  fontSize: 14),
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
          if (isLoading) // Indikator loading
            const Center(child: CircularProgressIndicator())
          else if (_selectedBoxIndex != -1) // Jika ada jadwal yang dipilih
            Expanded(
              child: ListView.builder(
                itemCount: jadwalHarianList.length,
                itemBuilder: (context, index) {
                  var jadwal = jadwalHarianList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeatSelectionScreen(
                            asal: widget.asal,
                            tujuan: widget.tujuan,
                            date: tanggal,
                            time:
                                "${formatTime(jadwal.waktuBerangkat)} - ${formatTime(jadwal.waktuKedatangan)}",
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1B1F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rp ${jadwal.harga}/Kursi",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Sarabun',
                                  fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.asal,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Sarabun',
                                      fontSize: 16),
                                ),
                                Image.asset('assets/icon/bus.png',
                                    width: 40, height: 40),
                                Text(
                                  widget.tujuan,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Sarabun',
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatTime(jadwal.waktuBerangkat),
                                  style: const TextStyle(
                                      color: Colors.cyan,
                                      fontFamily: 'Sarabun',
                                      fontSize: 16),
                                ),
                                const Text(
                                  "3 jam perjalanan",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Sarabun',
                                      fontSize: 14),
                                ),
                                Text(
                                  formatTime(jadwal.waktuKedatangan),
                                  style: const TextStyle(
                                      color: Colors.cyan,
                                      fontFamily: 'Sarabun',
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
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
}

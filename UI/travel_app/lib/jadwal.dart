import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_app/main.dart';
import 'CustomBottomNavigationBar.dart';
import 'SeatSelectionScreen.dart';

class Jadwal extends StatefulWidget {
  final String asal;
  final String tujuan;

  Jadwal({required this.asal, required this.tujuan});

  @override
  _JadwalState createState() => _JadwalState();
}

class _JadwalState extends State<Jadwal> {
  int _selectedIndex = 0;
  int _selectedBoxIndex = -1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String formatTime(int hour) {
    return hour.toString().padLeft(2, '0') + ":00";
  }

  @override
  Widget build(BuildContext context) {
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
                    color: Colors.white,
                    fontFamily: 'Sarabun',
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 30),
                ColorFiltered(
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  child: Image.asset(
                    'assets/icon/next.png',
                    width: 100,
                    height: 50,
                  ),
                ),
                Text(
                  widget.tujuan,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Sarabun',
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedBoxIndex = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: _selectedBoxIndex == index
                            ? Colors.cyan
                            : const Color(0xFF1A1B1F),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Mei",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Sarabun',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "${index + 1}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Sarabun',
                                fontSize: 14,
                              ),
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
          Visibility(
            visible: _selectedBoxIndex != -1,
            child: Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  int startHour = 8 + index * 3;
                  int endHour = startHour + 3;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeatSelectionScreen(
                            asal: widget.asal,
                            tujuan: widget.tujuan,
                            date: _selectedBoxIndex + 1,
                            time:
                                "${formatTime(startHour)} - ${formatTime(endHour)}",
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
                            const Text(
                              "Rp 45.000/Kursi",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Sarabun',
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${14 - index * 3} Kursi Tersisa",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Sarabun',
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.asal,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Sarabun',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Image.asset(
                                  'assets/icon/bus.png',
                                  width: 40,
                                  height: 40,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.tujuan,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Sarabun',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatTime(startHour),
                                  style: const TextStyle(
                                    color: Colors.cyan,
                                    fontFamily: 'Sarabun',
                                    fontSize: 16,
                                  ),
                                ),
                                const Text(
                                  "3 jam perjalanan",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Sarabun',
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  formatTime(endHour),
                                  style: const TextStyle(
                                    color: Colors.cyan,
                                    fontFamily: 'Sarabun',
                                    fontSize: 16,
                                  ),
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

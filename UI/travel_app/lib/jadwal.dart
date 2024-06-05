import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'SeatSelectionScreen.dart';
import 'main.dart'; // Import MyApp.dart file
import 'CustomBottomNavigationBar.dart'; // Import the custom bottom navigation bar

void main() {
  // Ensure binding is initialized before making changes to SystemChrome
  WidgetsFlutterBinding.ensureInitialized();

  // Hide the status bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(Jadwal());
}

class Jadwal extends StatefulWidget {
  @override
  _JadwalState createState() => _JadwalState();
}

class _JadwalState extends State<Jadwal> {
  int _selectedIndex = 0;
  int _selectedBoxIndex =
      -1; // Add a variable to keep track of the selected box

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
        break;
      case 1:
        // Navigate to ticket screen
        break;
      case 2:
        // Navigate to history screen
        break;
      case 3:
        // Navigate to profile screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor:
            const Color(0xFF121111), // Set background color of Scaffold
        body: Column(
          children: [
            Material(
              color:
                  const Color(0xFF121111), // Set background color of Material
              child: Row(
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    backgroundColor:
                        const Color(0xFF1A1B1F), // Background color of FAB
                    foregroundColor: Colors.white, // Icon color of FAB
                    tooltip: 'Tambah Item', // Tooltip on FAB hold
                    shape: const CircleBorder(), // Circular shape
                    child: ColorFiltered(
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      child: Image.asset('assets/icon/back.png'),
                    ),
                  ),
                  const SizedBox(width: 20), // Add spacing between text and FAB
                  const Text(
                    "Jogja",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Sarabun',
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                      width: 30), // Add spacing between text and image
                  ColorFiltered(
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    child: Image.asset(
                      'assets/icon/next.png',
                      width: 100, // Lebar gambar
                      height: 50, // Tinggi gambar
                    ),
                  ),
                  const Text(
                    "Semarang",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Sarabun',
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Add spacing below the Row
            Container(
              height: 60, // Set height of the ListView
              child: ListView.builder(
                //listview1
                scrollDirection: Axis.horizontal,
                itemCount: 8, // Number of items in the list
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedBoxIndex =
                            index; // Update the selected box index
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
            const SizedBox(
                height: 20), // Add spacing below the horizontal ListView
            // Start of vertical ListView for schedules
            Expanded(
              child: ListView.builder(
                //listview2
                itemCount: 6, // Number of schedule items
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SeatSelectionScreen()), // Navigate to SeatSelectionScreen
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
                              "${14 - index * 3} Kursi Tersisa", // Dynamic seat availability
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
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Town Hall",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Sarabun',
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "Jogjakarta",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Sarabun',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Image.asset(
                                  'assets/icon/bus.png', // Change to your bus image path
                                  width: 40,
                                  height: 40,
                                ),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Town Hall",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Sarabun',
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "Semarang",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Sarabun',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                "${index + 8}:00 AM - ${index + 11}:00 PM", // Dynamic time
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Sarabun',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // End of vertical ListView for schedules
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: (index) {
            _onItemTapped(index);
            _navigateToPage(context, index);
          },
        ),
      ),
    );
  }
}

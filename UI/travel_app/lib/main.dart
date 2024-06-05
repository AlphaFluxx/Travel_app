import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_app/splashScreen.dart';
import 'jadwal.dart';
import 'CustomBottomNavigationBar.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF121111),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF121111),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          selectedLabelStyle: TextStyle(
            color: Colors.white,
          ),
          unselectedLabelStyle: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
              child: TicketSearchForm(),
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

class TicketSearchForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDropdownField('Pilih Asal', FontAwesomeIcons.planeDeparture,
            Colors.blue, ['Jakarta', 'Surabaya', 'Bali']),
        const SizedBox(height: 16),
        _buildDropdownField('Pilih Tujuan', FontAwesomeIcons.planeArrival,
            Colors.red, ['Jakarta', 'Surabaya', 'Bali']),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Jadwal()));
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
      String labelText, IconData icon, Color iconColor, List<String> items) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: FaIcon(icon, color: iconColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {},
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Tambahkan import untuk FlutterToast
import 'package:travel_app/android/splashScreen.dart';
import 'booking/jadwal.dart';
import '/android/widget/CustomBottomNavigationBar.dart';

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
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
              child: FormPencarianTiket(),
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
  @override
  _FormPencarianTiketState createState() => _FormPencarianTiketState();
}

class _FormPencarianTiketState extends State<FormPencarianTiket> {
  String? _asalTerpilih;
  String? _tujuanTerpilih;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _bangunDropdownField(
          'Pilih Asal',
          'assets/icon/arah_biru.png',
          Colors.blue,
          ['Jogja', 'Solo', 'Semarang'],
          _asalTerpilih,
          (newValue) {
            setState(() {
              _asalTerpilih = newValue;
            });
          },
        ),
        const SizedBox(height: 16),
        _bangunDropdownField(
          'Pilih Tujuan',
          'assets/icon/arah_merah.png',
          Colors.red,
          ['Jogja', 'Solo', 'Semarang'],
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Jadwal(
                      asal: _asalTerpilih!,
                      tujuan: _tujuanTerpilih!,
                    ),
                  ),
                );
              } else {
                
                Fluttertoast.showToast(
                  msg: "Tolong pilih asal dan tujuan terlebih dahulu",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
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

  Widget _bangunDropdownField(
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

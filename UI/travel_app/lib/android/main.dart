import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'widget/animations.dart'; // Import file animations.dart
import '../android/home/homeScreen.dart';
import '../android/auth/loginScreen.dart';
import '../android/splashScreen.dart';

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
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data == true) {
            return HomeScreen(); // Menampilkan HomeScreen jika token ditemukan
          } else {
            return SplashScreen(); // Ganti dengan halaman login jika token tidak ditemukan
          }
        },
      ),
    );
  }

  // Fungsi untuk mengecek apakah token ada
  Future<bool> _checkLoginStatus() async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    return token != null;
  }
}

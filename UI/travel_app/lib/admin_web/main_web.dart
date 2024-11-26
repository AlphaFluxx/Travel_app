import 'package:flutter/material.dart';
import './auth/loginAdminScreen.dart';

void main() {
  runApp(AdminWebApp());
}

class AdminWebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue, // Warna utama aplikasi
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // Ubah warna AppBar
          iconTheme: IconThemeData(color: Colors.blue), // Warna ikon di AppBar
          titleTextStyle: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Warna default ElevatedButton
            foregroundColor: Colors.white, // Warna teks tombol
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue, // Warna teks untuk TextButton
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

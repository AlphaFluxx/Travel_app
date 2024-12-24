// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_declarations, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:travel_app/android/auth/signupscreen.dart';
import 'package:travel_app/android/widget/animations.dart';
import '../home/homeScreen.dart';

class LoginScreen extends StatelessWidget {
  // Inisialisasi FlutterSecureStorage
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> _loginUser(String email, String password) async {
      final String url = 'http://192.168.110.123:3306/pelanggan/akun/login';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': email, 'password': password}),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['token'] != null &&
              data['user'] != null &&
              data['user']['id_pelanggan'] != null) {
            await _secureStorage.write(key: 'jwt_token', value: data['token']);
            await _secureStorage.write(
                key: 'idpelanggan',
                value: data['user']['id_pelanggan'].toString());

            Fluttertoast.showToast(
              msg: "Login Successful",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );

            // Navigasi ke halaman utama
            Navigator.push(
              context,
              createFadeRoute(HomeScreen()),
            );
          } else {
            Fluttertoast.showToast(
              msg: "Login Failed: Data tidak lengkap",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: "Login Failed: ${response.reasonPhrase}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } catch (error) {
        Fluttertoast.showToast(
          msg: "Error: $error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF121111),
              Color(0xFFE121111),
              Color(0xFFF1211111)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xFF121111),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/image/logo_final_white.png',
                  height: 200,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Selamat Datang!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField('Email', 'assets/icon/email.png',
                            controller: emailController),
                        const SizedBox(height: 16),
                        _buildTextField('Password', 'assets/icon/lock.png',
                            isPassword: true, controller: passwordController),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            _loginUser(
                              emailController.text, // Kirim email
                              passwordController.text,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF10E0ED),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 15),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Belum mempunyai akun?"),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  createFadeRoute(SignUpScreen()),
                                );
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, String iconPath,
      {bool isPassword = false, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Container(
          padding: const EdgeInsets.all(10),
          child: Image.asset(iconPath, width: 20, height: 20),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}

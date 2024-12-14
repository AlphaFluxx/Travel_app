import 'package:flutter/material.dart';
import 'package:travel_app/android/auth/loginscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> _registerUser(
        String nama, String email, String password) async {
      final String url = 'http://192.168.110.123:3306/pelanggan/akun/register';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'nama': nama,
            'email': email,
            'password': password,
          }),
        );

        if (response.statusCode == 201) {
          // Registrasi berhasil
          Fluttertoast.showToast(
            msg: "Registrasi berhasil!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );

          // Navigasi ke halaman login
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          // Gagal registrasi, tampilkan pesan error
          final data = json.decode(response.body);
          Fluttertoast.showToast(
            msg: "Gagal: ${data['message'] ?? 'Kesalahan tidak diketahui'}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } catch (error) {
        // Error koneksi
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
              Color(0xFFF1211111),
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
                          'Mari Kita Mulai!',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField('Username', 'assets/icon/person.png',
                            controller: usernameController),
                        const SizedBox(height: 16),
                        _buildTextField('Email', 'assets/icon/email.png',
                            controller: emailController),
                        const SizedBox(height: 16),
                        _buildTextField('Password', 'assets/icon/lock.png',
                            isPassword: true, controller: passwordController),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text("Sudah mempunyai akun?"),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              child: const Text(
                                ' Login',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _registerUser(
                              usernameController.text,
                              emailController.text,
                              passwordController.text,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10E0ED),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 15),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white),
                          ),
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

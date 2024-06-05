import 'package:flutter/material.dart';
import 'package:travel_app/loginscreen.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  'assets/icon/mainlogo.png', // Use Image.asset for local assets
                  height: 100,
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
                          'hello!',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField('Username', 'assets/icon/person.png'),
                        const SizedBox(height: 16),
                        _buildTextField('Email', 'assets/icon/email.png'),
                        const SizedBox(height: 16),
                        _buildTextField('Password', 'assets/icon/lock.png',
                            isPassword: true),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              child: const Text(
                                'Already have an account? Login',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF10E0ED),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 15),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'or',
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton(Colors.red),
                            const SizedBox(width: 10),
                            _buildSocialButton(Colors.yellow),
                            const SizedBox(width: 10),
                            _buildSocialButton(Colors.blue),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          child: const Text(
                            "Don't have an account? Register",
                            style: TextStyle(color: Colors.black),
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
      {bool isPassword = false}) {
    return TextField(
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

  Widget _buildSocialButton(Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

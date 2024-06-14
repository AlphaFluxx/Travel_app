import 'package:flutter/material.dart';
import 'CustomBottomNavigationBar.dart'; // Import CustomBottomNavigationBar
import 'LoginScreen.dart'; // Import LoginScreen

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'assets/icon/profile_screen.png'), // Gambar profil Anda
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: const [
                              Text(
                                'Farhan Nugraha',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'farhan@gmail.com',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildProfileOption(
                            context, 'Ubah Kata Sandi', 'assets/icon/lock.png'),
                        _buildProfileOption(context, 'Ubah Email',
                            'assets/icon/email.png'),
                        _buildProfileOption(
                            context, 'Logout', 'assets/icon/logout.png'),
                      ],
                    ),
                  ),
                ),
              ),
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

  Widget _buildProfileOption(
      BuildContext context, String title, String iconPath) {
    return Column(
      children: [
        ListTile(
          leading: Image.asset(iconPath, width: 24, height: 24),
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500),
          ),
          trailing: const ImageIcon(
            AssetImage("assets/icon/panah_kanan.png"),
            color: Colors.black,
          ),
          onTap: () {
            if (title == 'Logout') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }
          },
        ),
        Divider(color: Colors.grey.shade300, thickness: 1),
      ],
    );
  }
}

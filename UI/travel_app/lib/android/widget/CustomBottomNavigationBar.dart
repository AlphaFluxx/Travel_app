import 'package:flutter/material.dart';
import 'package:travel_app/android/home/historyScreen.dart';
import '../home/homeScreen.dart'; // Impor MyApp.dart file
import '/android/profile/profileScreen.dart'; // Impor ProfileScreen.dart

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoryScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      items: const [
        BottomNavigationBarItem(
          backgroundColor: Colors.black,
          icon: ImageIcon(
            AssetImage('assets/icon/home.png'),
            color: Colors.white,
          ),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.black,
          icon: ImageIcon(
            AssetImage('assets/icon/history.png'),
            color: Colors.white,
          ),
          label: 'Riwayat',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.black,
          icon: ImageIcon(
            AssetImage('assets/icon/profile.png'),
            color: Colors.white,
          ),
          label: 'Profil',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(
        color: Colors.white,
      ),
      unselectedLabelStyle: const TextStyle(
        color: Colors.grey,
      ),
      onTap: (index) {
        onItemTapped(index);
        _navigateToPage(context, index);
      },
    );
  }
}

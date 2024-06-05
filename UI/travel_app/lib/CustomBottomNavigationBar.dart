// custom_bottom_navigation_bar.dart

import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

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
          label: 'Home',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.black,
          icon: ImageIcon(
            AssetImage('assets/icon/ticket.png'),
            color: Colors.white,
          ),
          label: 'Ticket',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.black,
          icon: ImageIcon(
            AssetImage('assets/icon/history.png'),
            color: Colors.white,
          ),
          label: 'History',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.black,
          icon: ImageIcon(
            AssetImage('assets/icon/profile.png'),
            color: Colors.white,
          ),
          label: 'Profile',
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
      onTap: onItemTapped,
    );
  }
}

import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('Admin Menu'),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: Text('Dashboard'),
            onTap: () {
              // Navigasi ke dashboard
            },
          ),
          ListTile(
            title: Text('Kelola Jadwal'),
            onTap: () {
              // Navigasi ke kelola jadwal
            },
          ),
          ListTile(
            title: Text('Kelola Transaksi'),
            onTap: () {
              // Navigasi ke kelola transaksi
            },
          ),
        ],
      ),
    );
  }
}

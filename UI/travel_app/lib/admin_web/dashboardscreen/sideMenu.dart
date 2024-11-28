// File ini mengatur tampilan menu samping (side menu).
// Menu ini berisi navigasi antar tabel yang memungkinkan pengguna memilih
// tabel (contohnya: Pelanggan atau Kursi) yang akan dikelola.

// side_menu.dart
// File ini mengelola menu samping untuk navigasi antar tabel (Pelanggan dan Kursi).

import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final Function(String) onTableSelected;

  const SideMenu({Key? key, required this.onTableSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          ListTile(
            leading: Image.asset(
              'assets/icon/next.png',
              width: 24,
              height: 24,
            ),
            title: const Text('Pelanggan'),
            onTap: () => onTableSelected('pelanggan'),
          ),
          ListTile(
            leading: Image.asset(
              'assets/icon/next.png',
              width: 24,
              height: 24,
            ),
            title: const Text('Kursi'),
            onTap: () => onTableSelected('kursi'),
          ),
          ListTile(
            leading: Image.asset(
              'assets/icon/next.png',
              width: 24,
              height: 24,
            ),
            title: const Text('Kendaraan'),
            onTap: () => onTableSelected('kendaraan'),
          ),
          ListTile(
            leading: Image.asset(
              'assets/icon/next.png',
              width: 24,
              height: 24,
            ),
            title: const Text('Transaksi'),
            onTap: () => onTableSelected('transaksi'),
          ),
          ListTile(
            leading: Image.asset(
              'assets/icon/next.png',
              width: 24,
              height: 24,
            ),
            title: const Text('Jadwalharian'),
            onTap: () => onTableSelected('jadwalharian'),
          ),
        ],
      ),
    );
  }
}

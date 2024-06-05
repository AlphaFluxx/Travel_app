import 'package:flutter/material.dart';

class TicketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: const Color(0xFF1A1B1F), // Background color of FAB
            foregroundColor: Colors.white, // Icon color of FAB
            tooltip: 'Back', // Tooltip on FAB hold
            shape: const CircleBorder(), // Circular shape
            child: ColorFiltered(
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              child: Image.asset('assets/icon/back.png'),
            ),
          ),
        ),
        title: const Text('Ticket', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Jogjakarta',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                          width: 8), // Adjust spacing between text and image
                      Image.asset(
                        'assets/icon/next.png',
                        width: 24, // Lebar gambar
                        height: 24, // Tinggi gambar
                      ),
                      const SizedBox(
                          width: 8), // Adjust spacing between image and text
                      const Text(
                        'Semarang',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/image/qrcode.png',
                    height: 150,
                    width: 150,
                  ), // replace with your QR code image path
                  const SizedBox(height: 20),
                  const Text(
                    'Nama',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const Text('Ahmad Farhan Nugraha'),
                  const SizedBox(height: 10),
                  const Text(
                    'Tanggal',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const Text('Mei 3, 2024'),
                  const SizedBox(height: 10),
                  const Text(
                    'Waktu',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const Text('08.00 AM - 11.00 AM'),
                  const SizedBox(height: 10),
                  const Text(
                    'Pickup - Drop Point',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const Text('Town Hall Jogjakarta - Town Hall Semarang'),
                  const SizedBox(height: 10),
                  const Text(
                    'Tempat duduk',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const Text('3'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle download action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
              ),
              child: const Text('Download Ticket',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

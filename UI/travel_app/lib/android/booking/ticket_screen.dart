import 'package:flutter/material.dart';

class TicketScreen extends StatelessWidget {
  final String asal;
  final String tujuan;
  final String date;
  final String time;
  final int seat;

  const TicketScreen({
    super.key,
    required this.asal,
    required this.tujuan,
    required this.date,
    required this.time,
    required this.seat,
  });

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
                      Text(
                        asal,
                        style: const TextStyle(
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
                      Text(
                        tujuan,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/image/qrcode.png',
                    height: 150,
                    width: 150,
                  ), 
                  const SizedBox(height: 20),
                  const Text(
                    'Nama',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text("farhan"),
                  const SizedBox(height: 10),
                  const Text(
                    'Tanggal',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text('Mei $date, 2024'),
                  const SizedBox(height: 10),
                  const Text(
                    'Waktu',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(time),
                  const SizedBox(height: 10),
                  const Text(
                    'Pickup - Drop Point',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Town Hall $asal - Town Hall $tujuan',
                    style: const TextStyle(
                        fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tempat duduk',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(seat.toString()),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
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

import 'package:flutter/material.dart';
import '../booking/ticket_screen.dart';

class PaymentScreen extends StatelessWidget {
  // final String asal;
  // final String tujuan;
  // final String date;
  // final String time;
  // final int seat;

  const PaymentScreen({
    super.key,
    // required this.asal,
    // required this.tujuan,
    // required this.date,
    // required this.time,
    // required this.seat,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // home: PaymentMethodScreen(
        // asal: asal,
        // tujuan: tujuan,
        // date: date,
        // time: time,
        // seat: seat,
        //   ),
        //   debugShowCheckedModeBanner: false,
        );
  }
}

class PaymentMethodScreen extends StatefulWidget {
  final String asal;
  final String tujuan;
  final String date;
  final String time;
  final int seat;

  const PaymentMethodScreen({
    super.key,
    required this.asal,
    required this.tujuan,
    required this.date,
    required this.time,
    required this.seat,
  });

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int selectedIndex = -1; // Track the selected card index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Pilih Metode Pembayaran',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: const Color(0xFF1A1B1F),
            foregroundColor: Colors.white,
            tooltip: 'Back',
            shape: const CircleBorder(),
            child: ColorFiltered(
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              child: Image.asset('assets/icon/back.png'),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PaymentMethodCard(
              isSelected: selectedIndex == 0,
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
            ),
            PaymentMethodCard(
              isSelected: selectedIndex == 1,
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
            ),
            PaymentMethodCard(
              isSelected: selectedIndex == 2,
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
              },
            ),
            const Spacer(),
            ConfirmButton(
              asal: widget.asal,
              tujuan: widget.tujuan,
              date: widget.date,
              time: widget.time,
              seat: widget.seat,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  PaymentMethodCard({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.cyan : Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 200,
              height: 30,
              color: Colors.grey[300],
            ),
          ),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isSelected ? Colors.white : Colors.cyan,
              ),
            ),
            child: Text(
              'Cara Kerja',
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xFF12D1DD),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  final String asal;
  final String tujuan;
  final String date;
  final String time;
  final int seat;

  const ConfirmButton({
    super.key,
    required this.asal,
    required this.tujuan,
    required this.date,
    required this.time,
    required this.seat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TicketScreen(
                asal: asal,
                tujuan: tujuan,
                date: date,
                time: time,
                seat: seat,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyan,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: const Text('Konfirmasi', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

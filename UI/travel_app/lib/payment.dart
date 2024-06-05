import 'package:flutter/material.dart';
import 'SeatSelectionScreen.dart';
import 'ticket_screen.dart'; // Import the new TicketScreen

void main() {
  runApp(PaymentScreen());
}

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaymentMethodScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PaymentMethodScreen extends StatefulWidget {
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SeatSelectionScreen(),
                ),
              );
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
            ConfirmButton(),
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
        color: isSelected
            ? Colors.cyan
            : Colors.white, // Update color based on selection
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
              // You can add a placeholder for the payment method name
            ),
          ),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isSelected
                    ? Colors.white
                    : Colors.cyan, // Update border color
              ),
            ),
            child: Text(
              'Cara Kerja',
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Color(0xFF12D1DD), // Update text color
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TicketScreen()),
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

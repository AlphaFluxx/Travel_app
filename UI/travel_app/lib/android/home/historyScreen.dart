import 'package:flutter/material.dart';
import '/android/widget/CustomBottomNavigationBar.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Riwayat',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Sarabun',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: TicketList()),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF1A1B1F),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class TicketList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2B2E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "15-Januari-2024",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Sarabun',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Town Hall",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Sarabun',
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Jogjakarta",
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Sarabun',
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/icon/bus.png',
                        width: 40,
                        height: 40,
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Town Hall",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Sarabun',
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Semarang",
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Sarabun',
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

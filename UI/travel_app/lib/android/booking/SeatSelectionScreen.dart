import 'package:flutter/material.dart';
import '/android/booking/jadwal.dart';
import '../payment/payment.dart';
import 'package:fluttertoast/fluttertoast.dart'; 

class SeatSelectionScreen extends StatefulWidget {
  final String asal;
  final String tujuan;
  final int date;
  final String time;

  const SeatSelectionScreen({
    super.key,
    required this.asal,
    required this.tujuan,
    required this.date,
    required this.time,
  });

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<bool> seats = List.generate(12, (index) => true);
  int selectedSeat = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121111),
        elevation: 0,
        title: const Text(
          "Pilih Kursi",
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
                  builder: (context) => Jadwal(
                    asal: widget.asal,
                    tujuan: widget.tujuan,
                  ),
                ),
              );
            },
            backgroundColor: const Color(0xFF1A1B1F), 
            foregroundColor: Colors.white,
            tooltip: 'Back', // 
            shape: const CircleBorder(), 
            child: ColorFiltered(
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              child: Image.asset('assets/icon/back.png'),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(48, 46, 46, 1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rp 45.000/Kursi",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "14 Kursi Tersisa",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Image.asset(
                      'assets/icon/bus.png', // Change to your garis image path
                    ),
                    const SizedBox(height: 4),
                    Image.asset(
                      'assets/icon/garis.png', // Change to your garis image path
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.time,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      widget.asal,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      widget.tujuan,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(48, 46, 46, 1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.0,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: seats.length,
                itemBuilder: (context, index) {
                  if (index == 2) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Center(
                        child: Text(
                          "Driver",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  } else if (index == 4 || index == 7 || index == 8) {
                    return GestureDetector(
                      onTap: () {
                        Fluttertoast.showToast(
                          msg: "Seat tidak tersedia",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            (index + 1).toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return GestureDetector(
                    onTap: seats[index]
                        ? () {
                            setState(() {
                              selectedSeat = index;
                            });
                          }
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedSeat == index
                            ? const Color(0xFF12D1DD)
                            : seats[index]
                                ? Colors.white
                                : Colors.black,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            color: selectedSeat == index || !seats[index]
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LegendItem(color: Colors.white, text: "Available"),
                LegendItem(color: Colors.black, text: "Unavailable"),
                LegendItem(color: Color(0xFF12D1DD), text: "Selected"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (selectedSeat != -1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentMethodScreen(
                        asal: widget.asal,
                        tujuan: widget.tujuan,
                        date: widget.date,
                        time: widget.time,
                        seat: selectedSeat + 1,
                      ),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "Pilih kursi terlebih dahulu",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
              },
              style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF12D1DD),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0))),
              child: const Text('Pilih', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({Key? key, required this.color, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

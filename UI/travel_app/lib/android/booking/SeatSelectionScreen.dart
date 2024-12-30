import '../service/kursiService.dart';
import 'package:flutter/material.dart';
import 'jadwalScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../payment/payment.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String asal;
  final String tujuan;
  final String tanggal;
  final String waktu_berangkat;
  final String waktu_kedatangan;
  final int idJadwal;
  final int idPelanggan;
  final int harga;
  final String jenisKendaraan;
  final int idKendaraan;

  const SeatSelectionScreen({
    super.key,
    required this.asal,
    required this.tujuan,
    required this.tanggal,
    required this.waktu_berangkat,
    required this.waktu_kedatangan,
    required this.idJadwal,
    required this.idPelanggan,
    required this.harga,
    required this.jenisKendaraan,
    required this.idKendaraan,
  });

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  late List<String?> seatLayout = [];
  late List<String?> fetchedSeats = [];

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final KursiService _kursiService = KursiService();

  int selectedSeat = -1;
  String? nomor_kursi;
  String? id_kursi;

  @override
  void initState() {
    super.initState();
    _initializeSeatLayout();
    _loadKursi();
  }

  void _initializeSeatLayout() {
    if (widget.jenisKendaraan.toLowerCase() == 'bus') {
      seatLayout = [
        null,
        null,
        null,
        "Driver",
        '1',
        null,
        '2',
        '3',
        '4',
        null,
        '5',
        '6',
        '7',
        null,
        '8',
        '9',
        '10',
        null,
        '11',
        '12',
        '13',
        null,
        '14',
        '15',
        '16',
        null,
        '17',
        '18',
        '19',
        null,
        '20',
        '21',
      ];
    } else if (widget.jenisKendaraan.toLowerCase() == 'hiace') {
      seatLayout = [
        '1',
        null,
        null,
        "Driver",
        null,
        '2',
        '3',
        '4',
        '5',
        null,
        '6',
        '7',
        '8',
        null,
        '9',
        '10',
        null,
        '11',
        '12',
        null,
        null,
        null,
        null,
        null,
      ];
    } else {
      seatLayout = List.generate(12, (index) => (index + 1).toString());
    }
  }

  void _loadKursi() async {
    try {
      String? token = await secureStorage.read(key: 'jwt_token');
      if (token == null) {
        throw Exception("Token tidak ditemukan.");
      }

      print("Token berhasil dibaca: $token");

      final data = await _kursiService.fetchKursi(widget.idKendaraan, token);

      // Debug: Log data kursi yang diambil
      print("Data kursi yang diambil: $data");
      print("Data Kendaraan yang diambil dengan id : ${widget.idKendaraan}");

      setState(() {
        fetchedSeats = seatLayout.map<String?>((seat) {
          if (seat == null || seat == "Driver") {
            return null;
          }
          final kursi = data.firstWhere(
            (item) => item['nomor_kursi']?.toString() == seat,
            orElse: () => {},
          );

          return kursi.isNotEmpty && kursi['statusKetersediaan'] == true
              ? kursi['id_kursi']?.toString()
              : null;
        }).toList();
      });

      // Debug: Log hasil akhir fetchedSeats
      print("Hasil fetchedSeats: $fetchedSeats");
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Gagal memuat data kursi: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      print("Error saat memuat kursi: $e");
    }
  }

  String formatWaktu(String waktu) {
    return waktu.substring(0, 5);
  }

  void _onSeatSelected(int index, String seat) {
    setState(() {
      selectedSeat = index;
      nomor_kursi = seat;

      final kursi = fetchedSeats[index];
      if (kursi != null) {
        id_kursi = kursi; 
        print("Kursi dipilih: $seat, ID Kursi: $id_kursi");
      } else {
        id_kursi = null;
        print("Kursi tidak tersedia: $seat");
      }
    });
  }

  void _onPilihPressed() {
    if (selectedSeat != -1 && nomor_kursi != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            asal: widget.asal,
            tujuan: widget.tujuan,
            tanggal: widget.tanggal,
            waktuBerangkat: widget.waktu_berangkat,
            waktuKedatangan: widget.waktu_kedatangan,
            idJadwal: widget.idJadwal,
            idPelanggan: widget.idPelanggan,
            harga: widget.harga,
            jenisKendaraan: widget.jenisKendaraan,
            idKendaraan: widget.idKendaraan,
            nomor_kursi: int.parse(nomor_kursi!),
            idKursi: int.parse(id_kursi!),
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
  }

  Widget _buildSeat(String? seat, int index) {
    if (seat == null) return const SizedBox.shrink();

    // Kursi dianggap tersedia jika tidak null di `fetchedSeats`
    bool isAvailable =
        index < fetchedSeats.length && fetchedSeats[index] != null;

    if (seat == "Driver") {
      return Container(
        decoration: BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.red, width: 2),
        ),
        child: const Center(
          child: Text(
            "Driver",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: isAvailable ? () => _onSeatSelected(index, seat) : null,
      child: Container(
        decoration: BoxDecoration(
          color: isAvailable
              ? (selectedSeat == index ? const Color(0xFF12D1DD) : Colors.white)
              : Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            seat,
            style: TextStyle(
              color: isAvailable
                  ? (selectedSeat == index ? Colors.white : Colors.black)
                  : Colors.black, // Tetap menampilkan angka dengan warna hitam
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121111),
        elevation: 0,
        title: const Text("Pilih Kursi", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: FloatingActionButton(
            onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Jadwal(
                      asal: widget.asal,
                      tujuan: widget.tujuan,
                    ),
                  ),
                ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
            tooltip: 'Back',
            shape: const CircleBorder(),
            child: Image.asset('assets/icon/back.png')),
      ),
      body: Column(
        children: [
          _buildInfoSection(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.3,
              ),
              itemCount: seatLayout.length,
              itemBuilder: (context, index) =>
                  _buildSeat(seatLayout[index], index),
            ),
          ),
          _buildLegend(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _onPilihPressed,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF12D1DD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Pilih', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(48, 46, 46, 1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Rp ${widget.harga}/Kursi",
                style: const TextStyle(color: Colors.white)),
            const Text("14 Kursi Tersisa",
                style: TextStyle(color: Colors.grey)),
          ]),
          Column(children: [
            Image.asset('assets/icon/bus.png'),
            const SizedBox(height: 4),
            Image.asset('assets/icon/garis.png'),
            const SizedBox(height: 4),
            Text(
                "${formatWaktu(widget.waktu_berangkat)} - ${formatWaktu(widget.waktu_kedatangan)}",
                style: const TextStyle(color: Colors.grey)),
          ]),
          Column(children: [
            Text(widget.asal, style: const TextStyle(color: Colors.white)),
            Text(widget.tujuan, style: const TextStyle(color: Colors.white)),
          ]),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          LegendItem(
            color: Colors.white,
            text: "Available",
            statusKetersediaan: true,
          ),
          LegendItem(
            color: Colors.black,
            text: "Booked",
            statusKetersediaan: false,
          ),
          LegendItem(
            color: Color(0xFF12D1DD),
            text: "Selected",
            statusKetersediaan: true,
          ),
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  final bool statusKetersediaan;

  const LegendItem({
    Key? key,
    required this.color,
    required this.text,
    required this.statusKetersediaan,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: statusKetersediaan ? color : Colors.grey,
            borderRadius: BorderRadius.circular(5),
            border: statusKetersediaan
                ? null
                : Border.all(color: Colors.black, width: 1),
          ),
          child: statusKetersediaan
              ? GestureDetector(
                  onTap: () {},
                )
              : null,
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

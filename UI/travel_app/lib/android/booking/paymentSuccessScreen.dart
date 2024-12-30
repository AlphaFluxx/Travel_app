import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mengambil arguments yang dikirim dari PaymentScreen
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      // Jika args tidak ditemukan, tampilkan pesan error atau lakukan tindakan yang sesuai
      return Scaffold(
        body: Center(child: Text("Data tidak ditemukan")),
      );
    }

    final orderId = args['orderId'];
    final statusCode = args['statusCode'];
    final transactionStatus = args['transactionStatus'];
    final nama = args['nama'];
    final email = args['email'];
    final titikPenjemputan = args['titikPenjemputan'];
    final titikTujuan = args['titikTujuan'];
    final tanggal = args['tanggal'];
    final waktuKeberangkatan = args['waktuKeberangkatan'];
    final waktuKedatangan = args['waktuKedatangan'];
    final jenisArmada = args['jenisArmada'];
    final nomorKursi = args['nomorKursi'];
    final harga = args['harga'];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF121111),
              Color(0xFFE121111),
              Color(0xFFF1211111),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xFF121111),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image/logo_final_white.png',
                    width: 200,
                    height: 150,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Payment Success",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildSectionHeader("Payment Details"),
                      _buildCard(
                        child: Column(
                          children: [
                            _buildRow("Order ID", orderId ?? 'N/A'),
                            _buildRow("Status Code", statusCode ?? 'N/A'),
                            _buildRow("Transaction Status",
                                transactionStatus ?? 'N/A'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSectionHeader("Customer Information"),
                      _buildCard(
                        child: Column(
                          children: [
                            _buildRow("Nama", nama ?? 'N/A'),
                            _buildRow("Email", email ?? 'N/A'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSectionHeader("Journey Details"),
                      _buildCard(
                        child: Column(
                          children: [
                            _buildRow("Titik Penjemputan", titikPenjemputan),
                            _buildRow("Titik Tujuan", titikTujuan),
                            _buildRow("Tanggal", tanggal),
                            _buildRow(
                                "Waktu Keberangkatan", waktuKeberangkatan),
                            _buildRow("Waktu Kedatangan", waktuKedatangan),
                            _buildRow("Jenis Armada", jenisArmada),
                            _buildRow("Nomor Kursi", nomorKursi),
                            _buildRow("Harga", _formatCurrency(harga)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Ganti '/home' dengan nama route yang sesuai untuk layar home kamu
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home', // Ganti dengan route yang sesuai
                              (route) =>
                                  false, // Menghapus semua layar sebelumnya
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF12D1DD),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Back to Home",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black54),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}

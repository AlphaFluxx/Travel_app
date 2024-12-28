import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../service/paymentService.dart';

class PaymentScreen extends StatefulWidget {
  final String asal;
  final String tujuan;
  final String tanggal;
  final String waktuBerangkat;
  final String waktuKedatangan;
  final int idJadwal;
  final int idPelanggan;
  final String jenisKendaraan;
  final int nomor_kursi;
  final int harga;

  PaymentScreen({
    required this.asal,
    required this.tujuan,
    required this.tanggal,
    required this.waktuBerangkat,
    required this.waktuKedatangan,
    required this.idJadwal,
    required this.idPelanggan,
    required this.harga,
    required this.jenisKendaraan,
    required int idKendaraan,
    required this.nomor_kursi,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _secureStorage = const FlutterSecureStorage();
  String? nama;
  String? email;
  late String token;

  @override
  void initState() {
    super.initState();
    _fetchNama();
  }

  Future<void> _handlePayment() async {
    final orderId = "ORDER-${DateTime.now().millisecondsSinceEpoch}";

    void _showMessage(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
    }

    // Validasi nama dan email sebelum melanjutkan
    if (nama == null || nama!.isEmpty || email == null || email!.isEmpty) {
      _showMessage("Nama dan email harus diisi sebelum melakukan pembayaran.");
      return;
    }

    final requestData = {
      "orderId": orderId,
      "grossAmount": widget.harga,
      "customerDetails": {
        "first_name": nama!,
        "last_name": "",
        "email": email!,
        "phone": "081234567890"
      }
    };

    print("Request Data: $requestData");

    try {
      PaymentService.processPayment(
        orderId: orderId,
        grossAmount: widget.harga,
        firstName: nama ?? "Unknown",
        email: email ?? "unknown@gmail.com",
        token: token,
        onSuccess: (paymentUrl) async {
          print("Payment URL received: $paymentUrl");
          try {
            await PaymentService.openPaymentUrl(paymentUrl);

            // Mendapatkan status transaksi
            final notificationResult =
                await PaymentService.checkTransactionStatus(orderId, token);

            if (notificationResult['status'] == 'success') {
              print("Pembayaran berhasil. Menampilkan hasil konfirmasi.");
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ConfirmationScreen(
              //       orderId: orderId,
              //       asal: widget.asal,
              //       tujuan: widget.tujuan,
              //       tanggal: widget.tanggal,
              //       waktuBerangkat: widget.waktuBerangkat,
              //       waktuKedatangan: widget.waktuKedatangan,
              //       jenisKendaraan: widget.jenisKendaraan,
              //       nomorKursi: widget.nomor_kursi,
              //       harga: widget.harga,
              //     ),
              //   ),
              // );
            } else {
              _showMessage("Pembayaran gagal. Silakan coba lagi.");
            }
          } catch (e) {
            print("Error handling payment: $e");
            _showMessage("Error memproses pembayaran: $e");
          }
        },
        onError: (error) {
          print("Error from server: $error");
          _showMessage("Error dari server: $error");
        },
      );
    } catch (e) {
      print("Error processing payment: $e");
      _showMessage("Terjadi kesalahan: $e");
    }
  }

  Future<void> _fetchNama() async {
    String? fetchedNama = await _secureStorage.read(key: 'Nama');
    String? fetchedEmail = await _secureStorage.read(key: 'email');
    String? fetchedToken = await _secureStorage.read(key: 'jwt_token');
    if (fetchedToken != null) {
      print("Token berhasil diambil: $fetchedToken");
    } else {
      print("Token tidak ditemukan di storage.");
    }
    setState(() {
      nama = fetchedNama ?? 'Unknown';
      email = fetchedEmail ?? 'Unknown';
      token = fetchedToken ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
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
            // Header
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
                  // Logo Checkmark
                  Image.asset(
                    'assets/image/logo_final_white.png',
                    width: 200,
                    height: 150,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Payment",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Content
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
                      _buildSectionHeader("Ringkasan Pesanan"),
                      _buildCard(
                        child: Column(
                          children: [
                            _buildRow("Nama", nama ?? 'Loading...'),
                            _buildRow("Email", email ?? 'Loading...'),
                            _buildRow("Titik Penjemputan", widget.asal),
                            _buildRow("Titik Tujuan", widget.tujuan),
                            _buildRow("Tanggal", widget.tanggal),
                            _buildRow(
                                "Waktu Keberangkatan", widget.waktuBerangkat),
                            _buildRow(
                                "Waktu Kedatangan", widget.waktuKedatangan),
                            _buildRow("Jenis Armada", widget.jenisKendaraan),
                            _buildRow(
                                "Nomor Kursi", widget.nomor_kursi.toString()),
                            _buildRow("Harga", _formatCurrency(widget.harga)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Space for vehicle image
                      if (widget.jenisKendaraan.toLowerCase() == 'hiace') ...[
                        Center(
                          child: Image.asset(
                            'assets/image/hiace.png',
                            width: 230,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ] else if (widget.jenisKendaraan.toLowerCase() ==
                          'bus') ...[
                        Center(
                          child: Image.asset(
                            'assets/image/bus.png',
                            width: 230,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ] else ...[
                        const Center(
                          child: Text(
                            "Gambar tidak tersedia untuk jenis armada ini",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _handlePayment();
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
                            "Bayar",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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
}

String _formatCurrency(int amount) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  return formatter.format(amount);
}

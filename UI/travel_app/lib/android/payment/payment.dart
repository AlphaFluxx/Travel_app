import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../service/paymentService.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/widgets.dart';

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
  final int idKursi;

  PaymentScreen(
      {required this.asal,
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
      required this.idKursi});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _secureStorage = const FlutterSecureStorage();
  String? nama;
  String? email;
  late String token;

  StreamSubscription? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _fetchNama();
    _initDeepLinkListener();
  }

  // Fungsi untuk menangani callback deep link
  Future<void> _initDeepLinkListener() async {
    try {
      _linkSubscription = uriLinkStream.listen((Uri? uri) async {
        if (uri != null) {
          print('Received deep link: $uri');
          print('Query parameters: ${uri.queryParameters}');

          // Ambil parameter yang diperlukan dari deep link
          String? orderId =
              uri.queryParameters['order_id']; // order_id untuk Midtrans
          String? idTransaksi = uri.queryParameters[
              'id_transaksi']; // id_transaksi untuk sistem lokal
          String? statusCode = uri.queryParameters['status_code'];
          String? transactionStatus = uri.queryParameters['transaction_status'];

          // Debugging untuk memeriksa nilai yang diterima
          print(
              'Debug: orderId = $orderId, idTransaksi = $idTransaksi, statusCode = $statusCode, transactionStatus = $transactionStatus');

          // Cek jika id_transaksi ada di deep link
          if (idTransaksi != null &&
              statusCode == '200' &&
              transactionStatus == 'settlement') {
            // Lakukan navigasi atau update status kursi
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/payment-success',
                    arguments: {
                      'idTransaksi':
                          idTransaksi, // Kirim id_transaksi yang benar
                      'statusCode': statusCode,
                      'transactionStatus': transactionStatus,
                      'nama': nama ?? 'Unknown',
                      'email': email ?? 'Unknown',
                      'titikPenjemputan': widget.asal,
                      'titikTujuan': widget.tujuan,
                      'tanggal': widget.tanggal,
                      'waktuKeberangkatan': widget.waktuBerangkat,
                      'waktuKedatangan': widget.waktuKedatangan,
                      'jenisArmada': widget.jenisKendaraan,
                      'nomorKursi': widget.nomor_kursi.toString(),
                      'harga': widget.harga,
                    });
              }
            });

            try {
              // Update status kursi menggunakan id_transaksi yang sesuai
              await PaymentService.updateSeatStatus(
                widget.idKursi.toString(),
                false,
                idTransaksi,
                transactionStatus!,
              );
              print("Seat status updated successfully");
            } catch (e) {
              print("Failed to update seat status: $e");
            }
          } else {
            print('Invalid id_transaksi or transaction_status');
          }
        }
      });
    } catch (e) {
      print("Error while processing deep link: $e");
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handlePayment() async {
    final orderId =
        "${widget.idPelanggan}-${DateTime.now().millisecondsSinceEpoch}";

    void _showMessage(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
    }

    if (nama == null || nama!.isEmpty || email == null || email!.isEmpty) {
      _showMessage("Nama dan email harus diisi sebelum melakukan pembayaran.");
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Proses pembayaran
      await PaymentService.processPayment(
        idPelanggan: widget.idPelanggan,
        idKursi: widget.idKursi.toString(),
        idJadwal: widget.idJadwal.toString(),
        idTransaksi: orderId,
        grossAmount: widget.harga,
        firstName: nama ?? "Unknown",
        email: email ?? "unknown@gmail.com",
        token: token,
        onSuccess: (paymentUrl) async {
          await PaymentService.openPaymentUrl(paymentUrl);
        },
        onError: (error) {
          _showMessage("Pembayaran gagal: $error. Silakan coba lagi.");
        },
      );
    } finally {
      Navigator.pop(context); // Menutup dialog loading
    }
  }

  // Fungsi untuk mengambil data pengguna dari secure storage
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
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

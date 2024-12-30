import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  // Fungsi untuk memproses pembayaran
  static Future<void> processPayment({
    required String idTransaksi,
    required int grossAmount,
    required String firstName,
    required String email,
    required String token,
    required String idJadwal, // Tambahkan idJadwal
    required String idKursi, // Tambahkan idKursi
    required int idPelanggan,
    required Function(String paymentUrl) onSuccess,
    required Function(String error) onError,
  }) async {
    final requestData = {
      "id_transaksi": idTransaksi,
      "grossAmount": grossAmount,
      "customerDetails": {
        "id_pelanggan": idPelanggan,
        "first_name": firstName,
        "last_name": "",
        "email": email,
        "phone": "081234567890"
      },
      "id_jadwal": idJadwal,
      "id_kursi": idKursi,
    };

    try {
      print("Mengirim data request: ${json.encode(requestData)}");

      final response = await http.post(
        Uri.parse("http://192.168.110.123:3306/pelanggan/payment/create"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(requestData),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final paymentUrl = jsonResponse['redirect_url'];

        print("Received payment URL: $paymentUrl");

        if (paymentUrl != null && paymentUrl.startsWith("https://")) {
          print("Payment URL valid. Proceeding to open URL.");
          onSuccess(paymentUrl);
        } else {
          print("Invalid payment URL received: $paymentUrl");
          onError("URL pembayaran tidak valid.");
        }
      } else {
        final errorResponse = json.decode(response.body);
        print("Error Response: $errorResponse");
        onError(
            "Gagal memproses pembayaran. Kode status: ${response.statusCode}, Pesan: ${errorResponse['message']}");
      }
    } catch (e) {
      print("Error during payment processing: $e");
      onError("Terjadi kesalahan: $e");
    }
  }

  // Fungsi untuk membuka URL pembayaran
  static Future<void> openPaymentUrl(String paymentUrl) async {
    final Uri url = Uri.parse(paymentUrl);
    print("openPaymentUrl: Membuka URL $url");

    try {
      if (await canLaunchUrl(url)) {
        print("openPaymentUrl: URL valid. Attempting to open.");
        await launchUrl(url, mode: LaunchMode.externalApplication);
        print("openPaymentUrl: URL berhasil dibuka.");
      } else {
        print("openPaymentUrl: Cannot launch the URL: $url");
        throw Exception("Tidak dapat membuka URL pembayaran: $url");
      }
    } catch (e) {
      print("Error in openPaymentUrl: $e");
      throw Exception("Gagal membuka URL pembayaran");
    }
  }

  // Fungsi untuk memproses notifikasi dari Midtrans
  static Future<Map<String, dynamic>> handleNotification(
      String notificationData, String token) async {
    final url = 'http://192.168.110.123:3306/pelanggan/payment/notification';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: notificationData,
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['transaction_status'] == 'settlement') {
          final idKursi = result['id_kursi'];
          final statusKetersediaan = false;
          final idTransaksi = result['id_transaksi'];
          final transactionStatus = result['transaction_status'];

          await updateSeatStatus(
            idKursi,
            statusKetersediaan,
            idTransaksi,
            transactionStatus,
          );
        }
        return result;
      } else {
        throw Exception("Gagal memproses notifikasi.");
      }
    } catch (e) {
      throw Exception("Error handleNotification: $e");
    }
  }

  static Future<void> updateSeatStatus(String idKursi, bool statusKetersediaan,
      String idTransaksi, String transactionStatus) async {
    final url =
        'http://192.168.110.123:3306/pelanggan/payment/payment-callback';
    final requestData = {
      'id_kursi': idKursi,
      'statusKetersediaan': statusKetersediaan,
      'id_transaksi': idTransaksi,
      'transaction_status': transactionStatus,
    };

    print(
        'Debug: Sending request to update seat status with data: $requestData');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        print('Seat status updated successfully');
      } else {
        final errorResponse = json.decode(response.body);
        print('Failed to update seat status: $errorResponse');
        throw Exception("Failed to update seat status");
      }
    } catch (e) {
      print('Error updating seat status: $e');
    }
  }

  static Future<String> getPaymentStatus(String orderId) async {
    try {
      // Panggil API untuk memeriksa status pembayaran
      var response = await http.get(Uri.parse(
          'http://192.168.110.123:3306/payment/payment-status/$orderId'));

      if (response.statusCode == 200) {
        // Parse status pembayaran dari response
        var data = json.decode(response.body);
        return data['status'] ?? 'unknown';
      } else {
        throw Exception('Gagal mendapatkan status pembayaran');
      }
    } catch (e) {
      throw Exception('Error while fetching payment status: $e');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  static Future<void> processPayment({
    required String orderId,
    required int grossAmount,
    required String firstName,
    required String email,
    required Function(String paymentUrl) onSuccess,
    required Function(String error) onError,
  }) async {
    final requestData = {
      "orderId": orderId,
      "grossAmount": grossAmount,
      "customerDetails": {
        "first_name": firstName,
        "last_name": "",
        "email": email,
        "phone": "081234567890"
      }
    };

    print("Sending request: $requestData");

    try {
      final response = await http.post(
        Uri.parse("http://192.168.110.123:3306/pelanggan/payment/create"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(requestData),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final paymentUrl =
            jsonResponse['redirect_url']; // Fixed to 'redirect_url'
        if (paymentUrl != null) {
          onSuccess(paymentUrl);
        } else {
          onError("URL pembayaran tidak ditemukan dalam respons.");
        }
      } else {
        onError(
            "Gagal memproses pembayaran. Kode status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during payment request: $e");
      onError("Terjadi kesalahan: $e");
    }
  }

  static Future<void> openPaymentUrl(String paymentUrl) async {
    final Uri url = Uri.parse(paymentUrl);

    // Memeriksa apakah URL dapat diluncurkan
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppWebView);
    } else {
      print('Tidak dapat membuka URL: $paymentUrl');
      throw Exception('Tidak dapat membuka URL pembayaran.');
    }
  }
}

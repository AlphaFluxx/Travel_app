import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  static Future<void> processPayment({
    required String orderId,
    required int grossAmount,
    required String firstName,
    required String email,
    required String token, // Tambahkan token sebagai parameter
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
      },
      "token": token // Sertakan token dalam data request
    };

    try {
      final response = await http.post(
        Uri.parse("http://192.168.110.123:3306/pelanggan/payment/create"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final paymentUrl = jsonResponse['redirect_url'];
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
      onError("Terjadi kesalahan: $e");
    }
  }

  static Future<void> openPaymentUrl(String paymentUrl) async {
    final Uri url = Uri.parse(paymentUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppWebView);
    } else {
      throw Exception('Tidak dapat membuka URL pembayaran.');
    }
  }

  static Future<Map<String, dynamic>> checkTransactionStatus(
      String orderId, String token) async {
    final url =
        'http://192.168.110.123:3306/pelanggan/payment/notifications/$orderId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      print("Request URL: $url");
      print("Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print("Response Body: $result");
        return {
          "status":
              result['transaction_status'] == 'success' ? 'success' : 'failed'
        };
      } else {
        throw Exception(
            "Failed to fetch transaction status. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching transaction status: $e");
      throw Exception("Failed to fetch transaction status");
    }
  }
}

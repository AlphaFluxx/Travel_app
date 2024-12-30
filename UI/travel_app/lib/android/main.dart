import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uni_links/uni_links.dart';
import '../android/home/homeScreen.dart';
import '../android/splashScreen.dart';
import 'booking/paymentSuccessScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        print("Deep link received: $uri");
        if (uri.host == 'yourapp') {
          // Menggunakan WidgetsBinding untuk menunggu frame selesai
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              Navigator.pushNamed(context, '/payment-success', arguments: uri);
            }
          });
        }
      }
    }, onError: (Object err) {
      print("Error receiving deep link: $err");
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF121111),
      ),
      debugShowCheckedModeBanner: false,
      // Routes dan initial screen ditentukan di sini
      initialRoute: '/', // Menentukan route awal
      routes: {
        '/': (context) => FutureBuilder<bool>(
              future: _checkLoginStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data == true) {
                  return HomeScreen();
                } else {
                  return SplashScreen();
                }
              },
            ),
        '/payment-success': (context) => PaymentSuccessScreen(),
        '/home': (context) => HomeScreen(), // Menambahkan HomeScreen di routes
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    return token != null;
  }
}

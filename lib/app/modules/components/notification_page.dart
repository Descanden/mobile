import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    // Mendapatkan token perangkat
    messaging.getToken().then((token) {
      print("Device Token: $token");
    });

    // Minta izin notifikasi (khusus iOS)
    requestPermission();

    // Mendengarkan pesan di latar depan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Pesan diterima di latar depan: ${message.notification?.title}");
      // Implementasi untuk menampilkan notifikasi dalam aplikasi
    });

    // Mendengarkan pesan saat aplikasi dimatikan atau di background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Pesan yang membuka aplikasi: ${message.notification?.title}");
      // Arahkan pengguna ke halaman checkout
      Navigator.pushNamed(context, '/checkout');
    });
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Permission status: ${settings.authorizationStatus}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Push Notification"),
      ),
      body: Center(
        child: Text("Welcome to Firebase Push Notification!"),
      ),
    );
  }
}
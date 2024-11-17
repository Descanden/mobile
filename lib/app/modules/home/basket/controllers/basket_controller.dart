import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BasketController extends GetxController {
  final items = <Map<String, dynamic>>[].obs;
  final allSelected = false.obs;
  final selectedTotal = 0.obs;
  final selectedCount = 0.obs;

  // Initialize Firebase Messaging and Local Notifications
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
    fetchItemsFromFirestore(); // Fetch items from Firestore on init
  }

  Future<void> _initializeNotifications() async {
    print("Initializing notifications...");

    // Request permissions for iOS
    await _firebaseMessaging.requestPermission();
    print("Requested permission for Firebase Messaging.");

    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: androidSettings);

    try {
      await _localNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print("Notification tapped: ${response.payload}");
        if (response.payload != null) {
          // Example navigation based on payload
          // Get.toNamed('/yourRouteName', arguments: response.payload);
        }
      });
      print("Local notifications initialized successfully.");
      
      await _createNotificationChannel();
    } catch (e) {
      print("Error initializing local notifications: $e");
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received foreground message: ${message.notification?.title}");
      _showLocalNotification(message);
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> fetchItemsFromFirestore() async {
    try {
      // Fetch items from Firestore collection
      QuerySnapshot querySnapshot = await _firestore.collection('items').get();
      for (var doc in querySnapshot.docs) {
        items.add(doc.data() as Map<String, dynamic>);
      }
      print("Items fetched from Firestore: ${items.length}");
    } catch (e) {
      print("Error fetching items from Firestore: $e");
    }
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'your_channel_id', // Your channel ID
      'your_channel_name', // Your channel name
      description: 'Your channel description', // Your channel description
      importance: Importance.high,
      playSound: true,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
      print("Notification channel created successfully.");
    } else {
      print("Android plugin not found. Unable to create notification channel.");
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'your_channel_id', // Use the same channel ID as above
      'your_channel_name', // Use the same channel name as above
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    
    try {
      await _localNotificationsPlugin.show(
        message.notification?.hashCode ?? 0,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: message.data['payload'], // Pass additional data if needed
      );
    } catch (e) {
      print("Error showing local notification: $e");
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    // Perform actions when the app is in the background, e.g., showing a notification
  }

  Future<void> showReminderNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel_id',
      'Reminder Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    
    try {
      await _localNotificationsPlugin.show(
        0,
        'Jangan Lupa!',
        'Jangan lupa melakukan pemesanan langsung.',
        notificationDetails,
      );
    } catch (e) {
      print("Error showing reminder notification: $e");
    }
  }

  void addItem(Map<String, dynamic> item) {
    final existingItemIndex = items.indexWhere((existingItem) =>
        existingItem['product']['id'] == item['product']['id'] &&
        existingItem['size'] == item['size']);

    if (existingItemIndex != -1) {
      items[existingItemIndex]['quantity']++;
    } else {
      items.add({...item, 'selected': false});
    }
    calculateSelectedTotal();
  }

  void increaseQuantity(int index) {
    items[index]['quantity']++;
    calculateSelectedTotal();
  }

  void decreaseQuantity(int index) {
    if (items[index]['quantity'] == 1) {
      Get.defaultDialog(
        title: "Remove Item",
        middleText: "Are you sure you want to remove this item?",
        confirm: ElevatedButton(
          onPressed: () {
            removeItem(index);
            Get.back();
          },
          child: const Text("Yes"),
        ),
        cancel: TextButton(
          onPressed: () => Get.back(),
          child: const Text("No"),
        ),
      );
    } else {
      items[index]['quantity']--;
      calculateSelectedTotal();
    }
  }

  void removeItem(int index) {
    items.removeAt(index);
    calculateSelectedTotal();
  }

  void toggleItemSelection(int index) {
    items[index]['selected'] = !items[index]['selected'];
    calculateSelectedTotal();
    allSelected.value = items.every((item) => item['selected']);
  }

  void toggleSelectAll() {
    final newValue = !allSelected.value;
    allSelected.value = newValue;
    for (var item in items) {
      item['selected'] = newValue;
    }
    calculateSelectedTotal();
  }

  void calculateSelectedTotal() {
    int total = 0;
    int count = 0;
    for (var item in items) {
      if (item['selected']) {
        total += (item['product']['price'] is num ? (item['product']['price'] as num).toInt() : 0) *
            (item['quantity'] is num ? (item['quantity'] as num).toInt() : 1);
        count += (item['quantity'] is num ? (item['quantity'] as num).toInt() : 1);
      }
    }
    selectedTotal.value = total;
    selectedCount.value = count;
  }

  void checkout() {
    // Handle checkout
  }
}

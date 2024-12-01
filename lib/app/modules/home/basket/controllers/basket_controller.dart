import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BasketController extends GetxController {
  final items = <Map<String, dynamic>>[].obs;
  final allSelected = false.obs;
  final selectedTotal = 0.obs;
  final selectedCount = 0.obs;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var selectedAddress = ''.obs;

  var selectedName;

  var isLoading;

  var transactionNote; // To store selected address

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
    fetchItemsFromFirestore();
  }

  Future<void> fetchItemsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('items').get();
      for (var doc in querySnapshot.docs) {
        items.add(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching items from Firestore: $e");
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
    updateSelectedTotal();
  }

  void increaseQuantity(int index) {
    items[index]['quantity']++;
    updateSelectedTotal();
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
      updateSelectedTotal();
    }
  }

  void removeItem(int index) {
    items.removeAt(index);
    updateSelectedTotal();
  }

  void toggleItemSelection(int index) {
    items[index]['selected'] = !items[index]['selected'];
    updateSelectedTotal();
    allSelected.value = items.every((item) => item['selected']);
  }

  void toggleSelectAll() {
    final newValue = !allSelected.value;
    allSelected.value = newValue;
    for (var item in items) {
      item['selected'] = newValue;
    }
    updateSelectedTotal();
  }

  void updateSelectedTotal() {
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

  void checkout() {
    // Pastikan ada barang yang dipilih dan alamat sudah ada
    if (selectedAddress.isEmpty) {
      Get.snackbar('Alamat Belum Dilengkapi', 'Silakan pilih alamat pengiriman terlebih dahulu.');
      return;
    }

    final selectedItems = items.where((item) => item['selected']).toList();
    if (selectedItems.isEmpty) {
      Get.snackbar('Tidak Ada Barang', 'Pilih barang terlebih dahulu sebelum checkout.');
      return;
    }

    // Proses checkout, misalnya simpan data ke Firestore
    _firestore.collection('orders').add({
      'items': selectedItems,
      'address': selectedAddress.value,
      'total': selectedTotal.value,
      'status': 'pending', // Status bisa ditentukan sesuai dengan alur
      'createdAt': FieldValue.serverTimestamp(),
    }).then((value) {
      Get.snackbar('Sukses', 'Pesanan Anda berhasil diproses.');
      items.clear(); // Bersihkan keranjang setelah checkout
      selectedTotal.value = 0;
      selectedCount.value = 0;
      selectedAddress.value = ''; // Reset alamat
    }).catchError((error) {
      Get.snackbar('Gagal', 'Terjadi kesalahan saat memproses pesanan.');
      print("Error adding order: $error");
    });
  }

  void _initializeNotifications() {
    const androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings = InitializationSettings(android: androidInitializationSettings);
    _localNotificationsPlugin.initialize(initializationSettings);
  }

  // Method to set or update the address
  void setAddress(String newAddress) {
    selectedAddress.value = newAddress;
  }

  void setName(result) {}

  void setTransactionNote(String note) {}

  void setNote(String text) {}
}

RxString userNote = ''.obs;

void setNote(String note) {
  userNote.value = note;
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/basket_controller.dart';

class BasketView extends GetView<BasketController> {
  const BasketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basket'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return const Center(child: Text('No items in the basket.'));
        }

        return ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            final item = controller.items[index];
            return ListTile(
              title: Text(item['product']['title']),
              subtitle: Text('Size: ${item['size']} | Qty: ${item['quantity']}'),
            );
          },
        );
      }),
    );
  }
}

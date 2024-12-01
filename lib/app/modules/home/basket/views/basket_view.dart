import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pemrograman_mobile/app/routes/app_pages.dart';
import '../controllers/basket_controller.dart';

class BasketView extends GetView<BasketController> {

  BasketView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await controller.showReminderNotification(); // Trigger the reminder notification
        return true; // Allow back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Keranjang Saya'),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.items.isEmpty) {
            return const Center(child: Text('No items in the basket.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    return Dismissible(
                      key: ValueKey(item['product']['id']),
                      direction: DismissDirection.horizontal,
                      confirmDismiss: (direction) async {
                        return await Get.defaultDialog(
                          title: "Remove Item",
                          middleText:
                              "Are you sure you want to remove this item?",
                          confirm: ElevatedButton(
                            onPressed: () {
                              controller.removeItem(index);
                              Get.back();
                            },
                            child: const Text("Yes"),
                          ),
                          cancel: TextButton(
                            onPressed: () => Get.back(),
                            child: const Text("No"),
                          ),
                        );
                      },
                      background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white)),
                      secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: item['selected'],
                                  onChanged: (value) {
                                    controller.toggleItemSelection(index);
                                  },
                                ),
                                Image.network(
                                  item['product']['image'],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['product']['title'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      Text('Size Chart: ${item['size']}'),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text(
                                            'Rp ${item['product']['originalPrice']}',
                                            style: const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                              'Rp ${item['product']['price']}'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () {
                                              controller
                                                  .decreaseQuantity(index);
                                            },
                                          ),
                                          Text('${item['quantity']}'),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              controller
                                                  .increaseQuantity(index);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: controller.selectedCount.value > 0
          ? () => Get.toNamed(Routes.CHECKOUT)
          : null,
      child: Text(
        'Checkout (${controller.selectedCount.value} items)',
      ),
    ),
  ),
),

            ],
          );
        }),
      ),
    );
  }
}

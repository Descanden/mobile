import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/basket_controller.dart';

class BasketView extends GetView<BasketController> {
  const BasketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: item['selected'],
                              onChanged: (value) => controller.toggleItemSelection(index),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['product']['title'],
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text('Size Chart : ${item['size']}'),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        'Rp ${item['product']['originalPrice']}',
                                        style: const TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text('Rp ${item['product']['price']}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () => controller.decreaseQuantity(index),
                                      ),
                                      Text('${item['quantity']}'),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () => controller.increaseQuantity(index),
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
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: controller.allSelected.value,
                        onChanged: (value) => controller.toggleSelectAll(),
                      ),
                      const Text('Semua'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                      // Only display the total amount if it's greater than zero
                      Text(
                        controller.selectedTotal.value > 0 ? 'Rp ${controller.selectedTotal.value}' : '',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.selectedTotal.value > 0 ? controller.checkout : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF704F38), // Brown color for the button
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Proses', // Change button text to "Proses"
                    style: TextStyle(fontSize: 16, color: Colors.white), // Text color
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

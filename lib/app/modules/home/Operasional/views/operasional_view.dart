import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/operasional_controller.dart';

class OperasionalView extends GetView<OperasionalController> {
  const OperasionalView({super.key});

  @override
  Widget build(BuildContext context) {
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biaya Operasional'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: startDateController,
                    decoration: const InputDecoration(
                      labelText: 'Dari Tanggal',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        startDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                        controller.startDate.value = pickedDate; // Simpan tanggal ke controller
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: endDateController,
                    decoration: const InputDecoration(
                      labelText: 'Hingga Tanggal',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        endDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                        controller.endDate.value = pickedDate; // Simpan tanggal ke controller
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (controller.startDate.value != null && controller.endDate.value != null) {
                      final sortedExpenses = controller.getSortedExpenses(controller.startDate.value!, controller.endDate.value!);
                      controller.expenses.assignAll(sortedExpenses);
                    } else {
                      Get.snackbar('Error', 'Silahkan pilih tanggal terlebih dahulu.');
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Total Pengeluaran:'),
                const SizedBox(width: 8),
                Obx(() => Text(
                      'Rp ${controller.totalExpenditure.value}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            const Divider(height: 32, thickness: 1),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = controller.expenses[index];
                      return Card(
                        elevation: 2,
                        child: ListTile(
                          title: Text(expense['description']),
                          subtitle: Text('Rp ${expense['amount']} - ${expense['date']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              controller.deleteExpense(index);
                            },
                          ),
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/tambah-operasional');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

extension on OperasionalController {
  get startDate => null;
  
  get endDate => null;
}

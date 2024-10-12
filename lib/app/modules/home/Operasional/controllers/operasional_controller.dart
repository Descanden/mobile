import 'package:get/get.dart';

class OperasionalController extends GetxController {
  var expenses = <Map<String, dynamic>>[].obs; // Daftar pengeluaran
  var totalExpenditure = 0.obs; // Total pengeluaran

  // Metode untuk menambah pengeluaran
  void addExpense(String description, int amount, String date) {
    expenses.add({'description': description, 'amount': amount, 'date': date});
    calculateTotalExpenditure(); // Memperbarui total pengeluaran
  }

  // Metode untuk menghitung total pengeluaran
  void calculateTotalExpenditure() {
    totalExpenditure.value = expenses.fold(0, (sum, expense) {
      return sum + (expense['amount'] as int); // Pastikan tipe data adalah int
    });
  }

  // Metode untuk menghapus pengeluaran
  void deleteExpense(int index) {
    expenses.removeAt(index);
    calculateTotalExpenditure(); // Memperbarui total setelah penghapusan
  }

  // Metode untuk mendapatkan pengeluaran yang terurut berdasarkan tanggal
  List<Map<String, dynamic>> getSortedExpenses(DateTime start, DateTime end) {
    return expenses.where((expense) {
      final expenseDate = DateTime.parse(expense['date']);
      return expenseDate.isAfter(start.subtract(Duration(days: 1))) &&
             expenseDate.isBefore(end.add(Duration(days: 1)));
    }).toList();
  }
}

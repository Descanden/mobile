import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Model Supplier
class Supplier {
    String name;
    String phone;
    String address;
    String description;

  Supplier({
    required this.name,
    required this.phone,
    required this.address,
    required this.description,
  });

  // Method to convert Supplier to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'description': description,
    };
  }

  // Method to convert JSON to Supplier
  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      description: json['description'],
    );
  }
}

class SupplierController extends GetxController {
  final supplierList = <Supplier>[].obs;
  var filteredSuppliers = <Supplier>[].obs;

  // Constructor
  SupplierController() {
    loadSuppliers();
  }

  @override
  void onInit() {
    super.onInit();
    filteredSuppliers.value = supplierList;
  }

  // Method to add a new supplier
  void addSupplier(String name, String phone, String address, String description) {
    final newSupplier = Supplier(
      name: name,
      phone: phone,
      address: address,
      description: description,
    );
    supplierList.add(newSupplier);
    saveSuppliers(); // Save to GetStorage
    searchSupplier(''); // Reset search
  }

  // Method to save suppliers to GetStorage
  void saveSuppliers() {
    final box = GetStorage();
    box.write('suppliers', supplierList.map((supplier) => supplier.toJson()).toList());
  }

  // Method to load suppliers from GetStorage
  void loadSuppliers() {
    final box = GetStorage();
    var suppliersFromStorage = box.read<List<dynamic>>('suppliers');
    if (suppliersFromStorage != null) {
      supplierList.assignAll(suppliersFromStorage.map((supplier) => Supplier.fromJson(supplier)).toList());
    }
  }

  // Method to search suppliers
  void searchSupplier(String query) {
    if (query.isEmpty) {
      filteredSuppliers.value = supplierList;
    } else {
      filteredSuppliers.value = supplierList
          .where((supplier) => supplier.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Method to delete a supplier
  void deleteSupplier(Supplier supplier) {
    supplierList.remove(supplier);
    saveSuppliers(); // Update storage after deletion
  }

  // Method to update a supplier
  void updateSupplier(Supplier supplier) {
    int index = supplierList.indexOf(supplier);
    if (index != -1) {
      supplierList[index] = supplier; // Update supplier details
      saveSuppliers(); // Save updated list
    }
  }
}

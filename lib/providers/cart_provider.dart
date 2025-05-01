import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  void addItem(Map<String, dynamic> item) {
  // ตรวจสอบว่ามีรายการนี้ในตะกร้าหรือยัง
  final exists = _items.any((i) => i['id'] == item['id']);

  if (!exists) {
    // ถ้า "ยังไม่มี" ให้เพิ่มเข้าไป
    _items.add({...item, 'quantity': 1});
    notifyListeners();
  }
}

  void removeItem(Map<String, dynamic> item) {
    // หาตำแหน่งของรายการในตะกร้า
    final index = _items.indexWhere((i) => i['id'] == item['id']);
    
    if (index >= 0) {
      // ลบรายการออกจากตะกร้า
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

}
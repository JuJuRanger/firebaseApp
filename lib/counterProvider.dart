import 'package:flutter/material.dart';

class CounterProvider with ChangeNotifier {
  // สร้างฟังชั่นการนับ counter
  int value = 0;
  increment() {
    value++;

    // notifyListeners() แทน setState()
    notifyListeners();
  }
}

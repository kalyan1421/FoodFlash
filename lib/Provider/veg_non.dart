import 'package:flutter/material.dart';

class VegOnlyProvider extends ChangeNotifier {
  bool _isVegOnly = false;
  bool get isVegOnly => _isVegOnly;



  set isVegOnly(bool newValue) {
    _isVegOnly = newValue;
    notifyListeners();
  }
}

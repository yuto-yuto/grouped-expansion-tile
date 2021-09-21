import 'package:flutter/cupertino.dart';

class Notifier<T> extends ChangeNotifier {
  T _value;
  Notifier(this._value);

  set value(T value) {
    if (_value == value) {
      return;
    }
    _value = value;
    notifyListeners();
  }

  T get value => _value;
}

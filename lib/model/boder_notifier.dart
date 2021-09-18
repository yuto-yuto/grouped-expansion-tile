import 'package:flutter/cupertino.dart';

class BorderNotifier extends ChangeNotifier {
  late Border _border;
  final Border _initialBorder;
  BorderNotifier(this._initialBorder) {
    _border = _initialBorder;
  }

  Border get border => _border;

  set border(Border value) {
    if (_border == value) {
      return;
    }
    _border = value;
    notifyListeners();
  }
}

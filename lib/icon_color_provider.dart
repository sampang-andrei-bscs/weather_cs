import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class IconColorProvider extends ChangeNotifier {
  final _box = GetStorage();
  Color _color = CupertinoColors.systemRed; // Default color

  IconColorProvider() {
    _loadColor();
  }

  Color get color => _color;

  void _loadColor() {
    int? colorValue = _box.read('iconColor');
    if (colorValue != null) {
      _color = Color(colorValue);
    }
    notifyListeners();
  }

  void updateColor(Color newColor) {
    _color = newColor;
    _box.write('iconColor', newColor.value); // Save color persistently
    notifyListeners();
  }
}

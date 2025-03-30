import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class IconColorProvider extends ChangeNotifier {
  final GetStorage _box = GetStorage();
  Color _color = CupertinoColors.systemRed; // Default color

  IconColorProvider() {
    _loadColor();
  }

  Color get color => _color;

  Future<void> _loadColor() async {
    int? colorValue = _box.read('iconColor');
    if (colorValue != null && colorValue != _color.value) {
      _color = Color(colorValue);
      notifyListeners(); // Notify only if the color changes
    }
  }

  void updateColor(Color newColor) {
    if (newColor != _color) {
      _color = newColor;
      _box.write('iconColor', newColor.value); // Save color persistently
      notifyListeners();
    }
  }
}

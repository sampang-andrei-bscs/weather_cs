import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class IconColorProvider extends ChangeNotifier {
  final _box = GetStorage();
  Color _color = CupertinoColors.systemRed;

  IconColorProvider() {
    _loadColor();
  }

  Color get color => _color;

  void _loadColor() {
    final int? colorValue = _box.read<int>('iconColor');
    if (colorValue != null) {
      _color = Color.fromARGB(
        (colorValue >> 24) & 0xFF,
        (colorValue >> 16) & 0xFF,
        (colorValue >> 8) & 0xFF,
        colorValue & 0xFF,
      );
    }
    notifyListeners();
  }

  void updateColor(Color newColor) {
    _color = newColor;
    color.toARGB32();
    notifyListeners();
  }
}

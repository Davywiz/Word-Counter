import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  String savedText = '';
  String key = 'text';

  String get savedTextGetter => savedText;

  void saveTextFunction(String text) async {
    savedText = text;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, text);
  }

  Future<String> loadTextFunction() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(key)) {
      return '';
    }
    final extractedText = prefs.getString(key);

    savedText = extractedText!;
    notifyListeners();
    return savedText;
  }

  clearSavedText() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}

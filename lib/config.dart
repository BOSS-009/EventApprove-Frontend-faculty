import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config extends ChangeNotifier {
  String _baseURL = 'http://192.168.0.71:5001'; // Default fallback

  String get baseURL => _baseURL;

  Config() {
    _loadBaseURL(); // Load stored IP when app starts
  }

  void _loadBaseURL() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedIP = prefs.getString('server_IP');
    _baseURL = storedIP;
    notifyListeners();
    }

  Future<void> setBaseURL(String newURL) async {
    _baseURL = newURL;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_IP', newURL); // Store in local storage
    notifyListeners();
  }
}

// Create a global instance of Config
final config = Config();

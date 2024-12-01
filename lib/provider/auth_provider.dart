import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _token; // Add this line to declare the _token variable.

  String? get token => _token;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  Future<bool> loginUser(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      var response = await http.post(
        Uri.parse(
            'http://localhost:8000/users/login/'), // Replace with actual URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        // Handle specific errors if the backend provides them
        final errorData = jsonDecode(response.body);
        print('Login failed: ${errorData['detail'] ?? 'Unknown error'}');
        _isAuthenticated = false;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isAuthenticated = false;
      _isLoading = false;
      notifyListeners();
      print('Error during login: $e');
      return false;
    }
  }

  void logoutUser() {
    _isAuthenticated = false;
    _token = null;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  // Mock login function, replace with real API call
  Future<bool> loginUser(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulating network request with delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock login validation, replace with real authentication logic
    if (email == 'sumit@gmail.com' && password == '123') {
      _isAuthenticated = true;
    } else {
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();

    return _isAuthenticated;
  }

  // Function to log out the user
  void logoutUser() {
    _isAuthenticated = false;
    notifyListeners();
  }
}

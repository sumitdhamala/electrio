import 'dart:convert';
import 'dart:io';
import 'package:electrio/component/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String name = '';
  String email = '';
  String contact = '';
  String address = '';
  File? profileImage;
  String? _token; // Private variable for token

  /// **Get Token**
  String? get token => _token; // Public getter to access token

  /// **Set Token**
  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  /// **Register User**
  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String contact,
    required String address,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      var response = await http.post(
        Uri.parse('$url/users/register/'), // Replace with server IP
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'username': username,
          'email': email,
          'phone_no': contact,
          'address': address,
          'password': password,
          'confirm_password': confirmPassword,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print("User registered: $responseData");

        // Save data locally
        this.name = firstName;
        this.email = email;
        this.contact = contact;
        this.address = address;

        notifyListeners();
      } else {
        final errorResponse = jsonDecode(response.body);
        print('Error Response: $errorResponse');
        throw Exception(errorResponse['detail'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to register user: $e');
    }
  }

  /// **Fetch User Details**
  Future<void> fetchUserDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Get token from shared preferences if not already set
      _token ??= prefs.getString('token');

      if (_token == null) throw Exception('Token missing. Please log in.');

      final response = await http.get(
        Uri.parse('$url/users/me/'),
        headers: {
          'Authorization': 'Token $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        name = "${data['first_name']} ${data['last_name']}";
        email = data['email'] ?? '';
        contact = data['phone_no'] ?? '';
        address = data['address'] ?? '';
        notifyListeners();
      } else {
        throw Exception('Failed to fetch user details');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }
}

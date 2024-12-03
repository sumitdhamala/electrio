import 'dart:convert';
import 'dart:io';
import 'package:electrio/component/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String firstName = '';
  String lastName = '';
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
        Uri.parse('$url/users/register/'),
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
        this.firstName = firstName;
        this.lastName = lastName;
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
        firstName = data['first_name'] ?? '';
        lastName = data['last_name'] ?? '';
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

  /// **Update User Details**
  Future<void> updateUserDetails({
    required String firstName,
    required String lastName,
    required String email,
    required String contact,
    required String address,
  }) async {
    try {
      if (_token == null || _token!.isEmpty)
        throw Exception("User not authenticated");

      final response = await http.patch(
        Uri.parse('$url/users/me/update/'),
        headers: {
          'Authorization': 'Token $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone_no': contact,
          'address': address,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        this.firstName = data['first_name'];
        this.lastName = data['last_name'];
        this.email = data['email'];
        this.contact = data['phone_no'];
        this.address = data['address'];
        notifyListeners();
      } else {
        throw Exception("Failed to update user details");
      }
    } catch (e) {
      print("Error updating user details: $e");
      throw e;
    }
  }
   Future<void> registerVehicle({
    required String company,
    required String batteryCapacity,
    required String portType,
    required String vehicleNo,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$url/users/vehicles/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $_token', // Ensure the token is set
        },
        body: jsonEncode({
          'vehicle_company': company,
          'battery_capacity': batteryCapacity,
          'port_type': portType,
          'vehicle_no': vehicleNo,
          // 'charging_capacity':
        }),
      );

      if (response.statusCode == 201) {
        print('Vehicle registration successful: ${response.body}');
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to register vehicle');
      }
    } catch (e) {
      print('Error registering vehicle: $e');
      throw Exception('Failed to register vehicle');
    }
  }
}

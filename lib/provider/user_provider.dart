import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  String name = '';
  String email = '';
  String contact = '';
  String address = '';
  File? profileImage;
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
        Uri.parse(
            'http://localhost:8000/users/register/'), // Replace with server IP
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

        // Save the data locally or update state
        this.name = firstName;
        this.email = email;
        this.contact = contact;
        this.address = address;

        notifyListeners();
      } else {
        final errorResponse = jsonDecode(response.body);
        print('Error Response: ${errorResponse}');
        throw Exception(errorResponse['detail'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to register user: $e');
    }
  }
}

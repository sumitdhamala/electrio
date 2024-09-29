// user_provider.dart
import 'dart:io';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  // Direct public variables
  String name = '';
  String email = '';
  String contact = '';
  String address = '';
  File? profileImage;

  // Method to update user information
  void setUserInfo({
    required String name,
    required String email,
    required String contact,
    required String address,
    File? profileImage,
  }) {
    this.name = name;
    this.email = email;
    this.contact = contact;
    this.address = address;
    this.profileImage = profileImage;
    notifyListeners(); // Notify listeners when data changes
  }
}

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

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
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
        headers: {'Content-Type': 'application/json'},
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

        // Save token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['token']);
        setToken(responseData['token']); // Update the provider token

        notifyListeners();
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['detail'] ?? 'Unknown error occurred');
      }
    } catch (e) {
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
    required String chargingCapacity,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$url/users/vehicles/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $_token',
        },
        body: jsonEncode({
          'vehicle_company': company,
          'battery_capacity': batteryCapacity,
          'charging_port_type': portType,
          'vehicle_no': vehicleNo,
          'charging_capacity': chargingCapacity
        }),
      );
      print('Token in registerVehicle: $_token');
      print('Headers: ${{
        'Content-Type': 'application/json',
        'Authorization': 'Token $_token',
      }}');

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

  List<Map<String, dynamic>> vehicles = [];

  /// **Fetch User Vehicles**
  Future<void> fetchUserVehicles() async {
    try {
      if (_token == null || _token!.isEmpty) {
        throw Exception("User not authenticated");
      }

      final response = await http.get(
        Uri.parse('$url/users/vehicles/'),
        headers: {
          'Authorization': 'Token $_token',
          'Content-Type': 'application/json',
        },
      );

      print('Raw Response: ${response.body}'); // Debugging log

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check for "data" key inside the response
        if (data is Map<String, dynamic> &&
            data.containsKey('status') &&
            data.containsKey('data') &&
            data['data'] is List) {
          vehicles = List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception("Unexpected response format");
        }

        notifyListeners();
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(
            errorResponse['detail'] ?? 'Failed to fetch vehicle details');
      }
    } catch (e) {
      print("Error fetching vehicle details: $e");
      throw Exception('Failed to fetch vehicle details');
    }
  }

  Future<void> updateVehicleDetails({
    required int vehicleId,
    required String vehicleNo,
    required String company,
    required String batteryCapacity,
    required String chargingPortType,
    required String chargingCapacity,
  }) async {
    try {
      if (_token == null || _token!.isEmpty) {
        throw Exception("User not authenticated");
      }

      final response = await http.patch(
        Uri.parse(
            '$url/users/vehicles/$vehicleId/'), // Adjust the URL based on your API
        headers: {
          'Authorization': 'Token $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'vehicle_no': vehicleNo,
          'vehicle_company': company,
          'battery_capacity': batteryCapacity,
          'charging_port_type': chargingPortType,
          'charging_capacity': chargingCapacity,
        }),
      );

      if (response.statusCode == 200) {
        final updatedVehicle = jsonDecode(response.body);

        // Update the local vehicle list
        int vehicleIndex =
            vehicles.indexWhere((vehicle) => vehicle['id'] == vehicleId);
        if (vehicleIndex != -1) {
          vehicles[vehicleIndex] = updatedVehicle;
        }

        // Notify listeners to update the UI
        notifyListeners();
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['detail'] ?? 'Failed to update vehicle');
      }
    } catch (e) {
      throw Exception('Error updating vehicle: $e');
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      if (_token == null || _token!.isEmpty) {
        throw Exception("User not authenticated");
      }

      final response = await http.post(
        Uri.parse(
            '$url/users/change_password/'), // Replace with your actual endpoint
        headers: {
          'Authorization': 'Token $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['detail'] ?? 'Failed to change password');
      }
    } catch (e) {
      throw Exception('Error changing password: $e');
    }
  }

  Future<void> sendEmailVerification({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$url/users/send_verification_email/'), // Replace with your endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send verification email');
      }
    } catch (e) {
      throw Exception('Error sending verification email: $e');
    }
  }

  Future<void> verifyEmailOTP(
      {required String email, required String otp}) async {
    try {
      final response = await http.post(
        Uri.parse('$url/users/verify_otp/'), // Replace with your endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to verify OTP');
      }
    } catch (e) {
      throw Exception('Error verifying OTP: $e');
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$url/users/send_reset_password/'), // Replace with your endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send reset password email');
      }
    } catch (e) {
      throw Exception('Error sending reset password email: $e');
    }
  }

  Future<void> confirmResetPassword({
    required String email,
    required String otp,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$url/users/reset_password/'), // Replace with your endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'new_password': password,
          'confirm_password': confirmPassword,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to reset password');
      }
    } catch (e) {
      throw Exception('Error resetting password: $e');
    }
  }
}

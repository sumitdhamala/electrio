import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:electrio/component/constants/constants.dart';

class VehicleProvider extends ChangeNotifier {
  // Vehicle data variables
  List<Map<String, dynamic>> vehicles = [];
  Map<String, dynamic>? selectedVehicle;

  // Private token variable
  String? _token;

  /// **Get Token**
  String? get token => _token;

  /// **Set Token**
  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  /// **Load Token from Storage**
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }

  /// **Fetch Vehicle List**
  Future<void> fetchVehicles() async {
    try {
      if (_token == null) await loadToken();
      if (_token == null)
        throw Exception('User not authenticated. Token is null.');

      final response = await http.get(
        Uri.parse('$url/users/vehicles/'),
        headers: {
          'Authorization': 'Token $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          vehicles = List<Map<String, dynamic>>.from(data);
          notifyListeners();
        } else {
          throw Exception('Unexpected response format from API');
        }
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to fetch vehicles');
      }
    } catch (e) {
      log('Error fetching vehicles: $e');
      throw Exception('Error fetching vehicles: $e');
    }
  }

  /// **Fetch Vehicle Details by ID**
  Future<void> fetchVehicleDetails(String vehicleId) async {
    try {
      if (_token == null) await loadToken();
      if (_token == null)
        throw Exception('User not authenticated. Token is null.');

      final response = await http.get(
        Uri.parse('$url/users/vehicles/$vehicleId/'),
        headers: {
          'Authorization': 'Token $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        selectedVehicle = jsonDecode(response.body);
        notifyListeners();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to fetch vehicle details');
      }
    } catch (e) {
      log('Error fetching vehicle details: $e');
      throw Exception('Error fetching vehicle details: $e');
    }
  }

  // /// **Register a New Vehicle**
  // Future<void> registerVehicle({
  //   required String company,
  //   required String batteryCapacity,
  //   required String portType,
  //   required String vehicleNo,
  //   required String chargingCapacity,
  // }) async {
  //   try {
  //     if (_token == null) await loadToken();
  //     if (_token == null)
  //       throw Exception('User not authenticated. Token is null.');

  //     final response = await http.post(
  //       Uri.parse('$url/users/vehicles/'),
  //       headers: {
  //         'Authorization': 'Token $_token',
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'vehicle_company': company,
  //         'battery_capacity': batteryCapacity,
  //         'charging_port_type': portType,
  //         'vehicle_no': vehicleNo,
  //         'charging_capacity': chargingCapacity,
  //       }),
  //     );

  //     if (response.statusCode == 201) {
  //       // Refresh vehicle list after successful registration
  //       await fetchVehicles();
  //     } else {
  //       final error = jsonDecode(response.body);
  //       throw Exception(error['detail'] ?? 'Failed to register vehicle');
  //     }
  //   } catch (e) {
  //     log('Error registering vehicle: $e');
  //     throw Exception('Error registering vehicle: $e');
  //   }
  // }

  /// **Edit Vehicle**
  Future<void> editVehicle({
    required String vehicleId,
    required String company,
    required String batteryCapacity,
    required String portType,
    required String vehicleNo,
    required String chargingCapacity,
  }) async {
    try {
      if (_token == null) await loadToken();
      if (_token == null)
        throw Exception('User not authenticated. Token is null.');

      final response = await http.patch(
        Uri.parse('$url/users/vehicles/$vehicleId/'),
        headers: {
          'Authorization': 'Token $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'vehicle_company': company,
          'battery_capacity': batteryCapacity,
          'charging_port_type': portType,
          'vehicle_no': vehicleNo,
          'charging_capacity': chargingCapacity,
        }),
      );

      if (response.statusCode == 200) {
        // Refresh vehicle list and details after successful update
        await fetchVehicles();
        await fetchVehicleDetails(vehicleId);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to edit vehicle');
      }
    } catch (e) {
      log('Error editing vehicle: $e');
      throw Exception('Error editing vehicle: $e');
    }
  }
}

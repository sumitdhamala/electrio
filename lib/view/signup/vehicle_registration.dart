import 'package:electrio/component/custom_form_button.dart';
import 'package:electrio/component/custom_textfield.dart';
import 'package:electrio/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VehicleRegistrationPage extends StatefulWidget {
  const VehicleRegistrationPage({Key? key}) : super(key: key);

  @override
  State<VehicleRegistrationPage> createState() =>
      _VehicleRegistrationPageState();
}

@override
class _VehicleRegistrationPageState extends State<VehicleRegistrationPage> {
  final _vehicleFormKey = GlobalKey<FormState>();

  // Controllers
  final _companyController = TextEditingController();
  final _batteryCapacityController = TextEditingController();
  final _vehicleNoController = TextEditingController();
  final _chargingCapacityController = TextEditingController();

  // Dropdown for Port Type
  String? _selectedPortType;
  @override
  void initState() {
    super.initState();
    // Ensure token is loaded
    Provider.of<UserProvider>(context, listen: false).loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: SingleChildScrollView(
          child: Form(
            key: _vehicleFormKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Vehicle Registration",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                CustomInputField(
                  labelText: 'Vehicle Company',
                  hintText: 'Enter vehicle company',
                  controller: _companyController,
                  validator: (textValue) {
                    if (textValue == null || textValue.isEmpty) {
                      return 'Vehicle company is required!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  labelText: 'Battery Capacity',
                  hintText: 'Enter battery capacity',
                  controller: _batteryCapacityController,
                  validator: (textValue) {
                    if (textValue == null || textValue.isEmpty) {
                      return 'Battery capacity is required!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  labelText: 'Charging Capacity',
                  hintText: 'Enter Charging capacity',
                  controller: _chargingCapacityController,
                  validator: (textValue) {
                    if (textValue == null || textValue.isEmpty) {
                      return 'Charging capacity is required!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Charging Port Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    value: _selectedPortType,
                    items: [
                      'CCS1',
                      'CCS2',
                      'GB/T',
                    ]
                        .map((portType) => DropdownMenuItem(
                              value: portType,
                              child: Text(portType),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPortType = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a charging port type!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  labelText: 'Vehicle No.',
                  hintText: 'Enter vehicle number',
                  controller: _vehicleNoController,
                  validator: (textValue) {
                    if (textValue == null || textValue.isEmpty) {
                      return 'Vehicle number is required!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomFormButton(
                  innerText: 'Register Vehicle',
                  onPressed: _registerVehicle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _registerVehicle() async {
    if (_vehicleFormKey.currentState!.validate()) {
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Submitting vehicle data...')),
        );

        // Register vehicle
        await userProvider.registerVehicle(
          company: _companyController.text,
          batteryCapacity: _batteryCapacityController.text,
          portType: _selectedPortType!,
          vehicleNo: _vehicleNoController.text,
          chargingCapacity: _chargingCapacityController.text,
        );

        // Show success message and navigate to login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehicle registration successful!')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}

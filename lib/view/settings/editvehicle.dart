import 'package:electrio/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditVehicleScreen extends StatefulWidget {
  final Map<String, dynamic> vehicle;

  EditVehicleScreen({required this.vehicle});

  @override
  _EditVehicleScreenState createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _vehicleNoController;
  late TextEditingController _companyController;
  late TextEditingController _batteryCapacityController;
  late TextEditingController _chargingPortController;
  late TextEditingController _chargingCapacityController;

  @override
  void initState() {
    super.initState();
    _vehicleNoController =
        TextEditingController(text: widget.vehicle['vehicle_no']);
    _companyController =
        TextEditingController(text: widget.vehicle['vehicle_company']);
    _batteryCapacityController = TextEditingController(
        text: widget.vehicle['battery_capacity'].toString());
    _chargingPortController =
        TextEditingController(text: widget.vehicle['charging_port_type']);
    _chargingCapacityController = TextEditingController(
        text: widget.vehicle['charging_capacity'].toString());
  }

  @override
  void dispose() {
    _vehicleNoController.dispose();
    _companyController.dispose();
    _batteryCapacityController.dispose();
    _chargingPortController.dispose();
    _chargingCapacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Vehicle'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Color(0xFFf1f1f1), // Light grey background
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                    'Vehicle Number', _vehicleNoController, TextInputType.text),
                _buildTextField(
                    'Company', _companyController, TextInputType.text),
                _buildTextField('Battery Capacity (kWh)',
                    _batteryCapacityController, TextInputType.number),
                _buildTextField('Charging Port Type', _chargingPortController,
                    TextInputType.text),
                _buildTextField('Charging Capacity (kW)',
                    _chargingCapacityController, TextInputType.number),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await userProvider.updateVehicleDetails(
                          vehicleId: widget.vehicle['id'],
                          vehicleNo: _vehicleNoController.text,
                          company: _companyController.text,
                          batteryCapacity: _batteryCapacityController.text,
                          chargingPortType: _chargingPortController.text,
                          chargingCapacity: _chargingCapacityController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Vehicle updated successfully!')));
                        Navigator.pop(
                            context); // Go back to the previous screen
                      } catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child:
                        Text('Update Vehicle', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.green),
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field cannot be empty';
          }
          return null;
        },
      ),
    );
  }
}

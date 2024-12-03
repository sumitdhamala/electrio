import 'package:electrio/provider/user_provider.dart';
import 'package:electrio/view/settings/editvehicle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VehicleDetailsScreen extends StatefulWidget {
  @override
  _VehicleDetailsScreenState createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  late Future<void> _fetchVehiclesFuture;

  @override
  void initState() {
    super.initState();
    // Fetch vehicles when the screen is initialized
    _fetchVehiclesFuture =
        Provider.of<UserProvider>(context, listen: false).fetchUserVehicles();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Vehicles'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _fetchVehiclesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          final vehicles = userProvider.vehicles;

          if (vehicles.isEmpty) {
            return const Center(
              child: Text(
                'No vehicles registered.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: vehicles.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.directions_car,
                          size: 40,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            vehicle['vehicle_company'] ?? 'Unknown Company',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      label: 'Vehicle Number',
                      value: vehicle['vehicle_no'] ?? 'N/A',
                    ),
                    _buildDetailRow(
                      label: 'Battery Capacity',
                      value: '${vehicle['battery_capacity'] ?? 'N/A'} kWh',
                    ),
                    _buildDetailRow(
                      label: 'Charging Port Type',
                      value: vehicle['charging_port_type'] ?? 'N/A',
                    ),
                    _buildDetailRow(
                      label: 'Charging Capacity',
                      value: '${vehicle['charging_capacity'] ?? 'N/A'} kW',
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditVehicleScreen(vehicle: vehicles[index]),
                            ),
                          ).then((_) {
                            // When returning from the edit screen, refresh the vehicle list
                            userProvider.fetchUserVehicles();
                          });
                        },
                        child: const Text('Edit Vehicle'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

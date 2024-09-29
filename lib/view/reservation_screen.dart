import 'package:electrio/model/booking_model.dart';
import 'package:electrio/model/station_model.dart';
import 'package:electrio/view/booking_details.dart';
import 'package:electrio/provider/booking_provider.dart'; // Import the booking provider
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import provider

class ReservationScreen extends StatefulWidget {
  final Station station;

  const ReservationScreen({Key? key, required this.station}) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedPortType;
  final List<String> portTypes = ['CCS2', 'CHAdeMO', 'Type 2'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Reservation'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Station: ${widget.station.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.green),
              title: Text(
                selectedDate == null
                    ? 'Select Date'
                    : DateFormat.yMMMd().format(selectedDate!),
              ),
              trailing: Icon(Icons.arrow_drop_down, color: Colors.green),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              leading: Icon(Icons.access_time, color: Colors.green),
              title: Text(
                selectedTime == null
                    ? 'Select Time'
                    : selectedTime!.format(context),
              ),
              trailing: Icon(Icons.arrow_drop_down, color: Colors.green),
              onTap: () => _selectTime(context),
            ),
            const SizedBox(height: 16),
            const Text('Select Charging Port Type'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedPortType,
              items: portTypes.map((String port) {
                return DropdownMenuItem<String>(
                  value: port,
                  child: Text(port),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPortType = newValue;
                });
              },
              hint: const Text('Choose port type'),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedDate != null &&
                      selectedTime != null &&
                      selectedPortType != null) {
                    // Create a new booking instance
                    final booking = Booking(
                      stationName: widget.station.name,
                      date: DateFormat.yMMMd().format(selectedDate!),
                      time: selectedTime!.format(context),
                      portType: selectedPortType!,
                    );

                    // Add booking to provider
                    Provider.of<BookingProvider>(context, listen: false)
                        .addBooking(booking);

                    // Navigate to the BookingDetailsScreen with the reservation details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailsScreen(
                          stationName: widget.station.name,
                          date: DateFormat.yMMMd().format(selectedDate!),
                          time: selectedTime!.format(context),
                          portType: selectedPortType!,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fill in all details.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                ),
                child: const Text('Confirm Reservation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

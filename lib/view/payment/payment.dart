import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KhaltiPaymentScreen extends StatefulWidget {
  @override
  _KhaltiPaymentScreenState createState() => _KhaltiPaymentScreenState();
}

class _KhaltiPaymentScreenState extends State<KhaltiPaymentScreen> {
  final String publicKey =
      "9f74423ecb2f4131aef333d24d65a04e"; // Replace with your actual public key
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  Future<void> _makePayment() async {
    final amount = int.parse(_amountController.text) * 100; // Convert to paisa
    final mobile = _mobileController.text;
    final pin = _pinController.text;

    final url = Uri.parse("https://khalti.com/api/v2/payment/initiate/");
    final headers = {
      "Authorization": "Key $publicKey", // Public Key only
      "Content-Type": "application/json",
    };

    final body = {
      "public_key": publicKey,
      "mobile": mobile,
      "transaction_pin": pin,
      "amount": amount,
      "product_identity": "1234567890", // Example
      "product_name": "Test Product",
      "product_url": "https://example.com",
    };

    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Payment Successful! Transaction ID: ${responseData['idx']}"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Payment Failed! ${responseData['detail']}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred! Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Khalti Payment Gateway"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: "Amount (NPR)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _mobileController,
              decoration: InputDecoration(
                labelText: "Mobile Number",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _pinController,
              decoration: InputDecoration(
                labelText: "Khalti PIN",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _makePayment,
              child: Text("Pay Now"),
            ),
          ],
        ),
      ),
    );
  }
}
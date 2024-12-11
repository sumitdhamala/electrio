import 'package:electrio/component/customclip_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:electrio/provider/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String firstName, lastName, email, contact, address;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    firstName = userProvider.firstName ?? ''; // Replace with your provider data
    lastName = userProvider.lastName ?? '';
    email = userProvider.email ?? '';
    contact = userProvider.contact ?? '';
    address = userProvider.address ?? '';
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.updateUserDetails(
        firstName: firstName,
        lastName: lastName,
        email: email,
        contact: contact,
        address: address,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomCurvedAppBar(title: "Edit Profile"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              // First Name Field
              _buildTextField(
                "First Name",
                firstName,
                (value) => firstName = value,
              ),
              // Last Name Field
              _buildTextField(
                "Last Name",
                lastName,
                (value) => lastName = value,
              ),
              // Email Field
              _buildTextField(
                "Email",
                email,
                (value) => email = value,
                readOnly: true, 
              ),
              // Contact Field
              _buildTextField(
                "Contact",
                contact,
                (value) => contact = value,
              ),
              // Address Field
              _buildTextField(
                "Address",
                address,
                (value) => address = value,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  child: const Text(
                    "  Save Changes   ",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String initialValue,
    Function(String) onSaved, {
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        initialValue: initialValue,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label cannot be empty";
          }
          return null;
        },
        onSaved: (value) => onSaved(value!),
      ),
    );
  }
}

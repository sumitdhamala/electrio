import 'dart:ui';

import 'package:electrio/component/customclip_bar.dart';
import 'package:electrio/provider/user_provider.dart';
import 'package:electrio/view/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final token = userProvider.token;

      if (token != null && token.isNotEmpty) {
        await userProvider.fetchUserDetails();
      } else {
        setState(() {
          _errorMessage = "User not authenticated. Please log in again.";
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = "Failed to load user details. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomCurvedAppBar(
        title: "Profile",
        backgroundColor: Colors.green,
      ),
      body: _errorMessage != null
          ? Center(
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : userProvider.firstName.isEmpty && userProvider.lastName.isEmpty
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      // Profile Header Section
                      Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade800,
                              Colors.green.shade500
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 40.0, left: 20),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 55,
                                      backgroundColor: Colors.green.shade100,
                                      backgroundImage: userProvider
                                                  .profileImage !=
                                              null
                                          ? FileImage(
                                              userProvider.profileImage!)
                                          : const NetworkImage(
                                              "https://scontent.fpkr2-1.fna.fbcdn.net/v/t39.30808-6/467311013_2890105254492263_146244950505858188_n.jpg?stp=dst-jpg_p526x296&_nc_cat=110&ccb=1-7&_nc_sid=833d8c&_nc_eui2=AeExECEUBaUDEqiv6TLY2_1TLPKFmXboweEs8oWZdujB4R1vPySO5wWdYwn03AascpAUr8mtlgwfKvqY8FjWSfdT&_nc_ohc=txqLmBcQZgwQ7kNvgE7VW0G&_nc_zt=23&_nc_ht=scontent.fpkr2-1.fna&_nc_gid=AYkC9mGJgMkHFy2MXoGK3Zl&oh=00_AYB2cRMQwZiL0K1MzXmPTf2wG7p6uFmo-BmYJ7Na4BtUOQ&oe=67549ED7"),
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      "${userProvider.firstName} ${userProvider.lastName}"
                                              .trim()
                                              .isNotEmpty
                                          ? "${userProvider.firstName} ${userProvider.lastName}"
                                          : "N/A",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      // Information Cards
                      Card(
                        margin: EdgeInsets.only(top: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 6,
                        shadowColor: Colors.green.withOpacity(0.4),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              _buildProfileInfo(
                                  "Name",
                                  "${userProvider.firstName} ${userProvider.lastName}"
                                          .trim()
                                          .isNotEmpty
                                      ? "${userProvider.firstName} ${userProvider.lastName}"
                                      : "N/A",
                                  Icons.person),
                              _buildProfileInfo(
                                  "Email",
                                  userProvider.email.isNotEmpty
                                      ? userProvider.email
                                      : "N/A",
                                  Icons.email),
                              _buildProfileInfo(
                                  "Contact",
                                  userProvider.contact.isNotEmpty
                                      ? userProvider.contact
                                      : "N/A",
                                  Icons.phone),
                              _buildProfileInfo(
                                  "Address",
                                  userProvider.address.isNotEmpty
                                      ? userProvider.address
                                      : "N/A",
                                  Icons.location_on),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen()),
                          );
                        },
                        child: const Text("  Edit Profile  ",
                            style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 10,
                          shadowColor: Colors.green.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileInfo(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 28),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

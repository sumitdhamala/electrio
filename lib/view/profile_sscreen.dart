import 'package:electrio/component/customclip_bar.dart';
import 'package:electrio/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar:  CustomCurvedAppBar(title: "Settings", backgroundColor: Colors.green),
      body: userProvider.name.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // Profile Image Section
                  Center(
                    child: CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.blue.shade200,
                      backgroundImage: userProvider.profileImage != null
                          ? FileImage(userProvider.profileImage!)
                          : NetworkImage(
                              "https://scontent.fpkr2-1.fna.fbcdn.net/v/t39.30808-6/467311013_2890105254492263_146244950505858188_n.jpg?stp=dst-jpg_p526x296&_nc_cat=110&ccb=1-7&_nc_sid=833d8c&_nc_eui2=AeExECEUBaUDEqiv6TLY2_1TLPKFmXboweEs8oWZdujB4R1vPySO5wWdYwn03AascpAUr8mtlgwfKvqY8FjWSfdT&_nc_ohc=txqLmBcQZgwQ7kNvgHqkqiJ&_nc_zt=23&_nc_ht=scontent.fpkr2-1.fna&_nc_gid=AbX8GO3eRFnN07wNGgsbPKD&oh=00_AYCc4yZpzX_434vmZ9exHnBb7r37tagOHABmiB1YQxqzKw&oe=67523417"),
                    ),
                  ),
                  SizedBox(height: 20),
                  // User Details Section
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Name: ${userProvider.name}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Email: ${userProvider.email}",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Contact: ${userProvider.contact}",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Address: ${userProvider.address}",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Edit Button Section
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to edit profile screen (if any)
                    },
                    child: Text("Edit Profile", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

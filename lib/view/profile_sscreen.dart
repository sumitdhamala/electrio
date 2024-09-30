import 'package:electrio/component/customclip_bar.dart';
import 'package:electrio/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: CustomCurvedAppBar(title: "Profile"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Picture Section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: userProvider.profileImage != null
                        ? FileImage(userProvider.profileImage!)
                        : NetworkImage(
                                "https://scontent.fpkr1-1.fna.fbcdn.net/v/t39.30808-6/290922329_589428339501661_6456762287005615316_n.jpg?stp=cp6_dst-jpg_p526x296&_nc_cat=104&ccb=1-7&_nc_sid=833d8c&_nc_eui2=AeFq9Hckv5DL4Z-J5CpyhmnWez-40vxmCaN7P7jS_GYJo11gO0Clh3Tso07tMPOxfuqfqM46-MqFLaV6m6brPPM3&_nc_ohc=lxYhj3E4kWUQ7kNvgGDmgpA&_nc_ht=scontent.fpkr1-1.fna&_nc_gid=AKJhpcjDizlu9Y5ZrKTq8Us&oh=00_AYDOM5OurCmNLtnU57e9O5g3Fzls4pR3pgtxHOk-6cPQHg&oe=66FEFA1C")
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // Functionality to pick an image
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // User Information Section
            Expanded(
              child: ListView(
                children: [
                  _buildInfoCard(
                      title: "Name",
                      value: userProvider.name.isNotEmpty
                          ? userProvider.name
                          : 'Sumit Dhamala'),
                  _buildInfoCard(
                      title: "Email",
                      value: userProvider.email.isNotEmpty
                          ? userProvider.email
                          : 'sumit11dhamala@gmailcom'),
                  _buildInfoCard(
                      title: "Contact",
                      value: userProvider.contact.isNotEmpty
                          ? userProvider.contact
                          : '9805814575'),
                  _buildInfoCard(
                      title: "Address",
                      value: userProvider.address.isNotEmpty
                          ? userProvider.address
                          : 'Pokhara, Nepal'),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Action Buttons
            ElevatedButton(
              onPressed: () {
                // Add your edit profile functionality here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Edit Profile',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String value}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  overflow: TextOverflow.ellipsis,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:electrio/view/home/station/notification.dart'; // NotificationScreen
import 'package:electrio/component/notification_manager.dart'; // NotificationManager

class CustomCurvedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String? imgurl;
  final Color backgroundColor;
  final List<String>? notifications;

  CustomCurvedAppBar({
    super.key,
    required this.title,
    this.imgurl,
    this.backgroundColor = Colors.green,
    this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: AppBarClipper(),
      child: AppBar(
        leading: imgurl != null
            ? CircleAvatar(backgroundImage: NetworkImage(imgurl!))
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Pass the full notifications to NotificationScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(
                    notifications: NotificationManager.getNotifications(),
                  ),
                ),
              );
            },
          ),
        ],
        backgroundColor: backgroundColor,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

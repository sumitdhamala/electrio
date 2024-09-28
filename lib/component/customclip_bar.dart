// custom_curved_appbar.dart
import 'package:flutter/material.dart';

class CustomCurvedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;

  const CustomCurvedAppBar({
    Key? key,
    required this.title,
    this.backgroundColor = Colors.green, // Default color to green
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: AppBarClipper(),
      child: AppBar(
        backgroundColor: backgroundColor,
        title: Text(title),
        centerTitle: true,
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(120.0); // Sets the height of the AppBar
}

// Custom Clipper for Curving the AppBar
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
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

import 'package:electrio/view/signup/forget_password.dart';
import 'package:electrio/view/home_screen.dart';
import 'package:electrio/view/signup/loginpage.dart';
import 'package:electrio/view/signup/signup.dart';
import 'package:electrio/view/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/forgetPassword': (context) => ForgetPasswordPage(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

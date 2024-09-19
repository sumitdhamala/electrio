import 'package:electrio/view/forget_password.dart';
import 'package:electrio/view/home.dart';
import 'package:electrio/view/loginpage.dart';
import 'package:electrio/view/signup.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => Home(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/forgetPassword': (context) => ForgetPasswordPage(),
      },
    );
  }
}

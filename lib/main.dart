import 'package:electrio/provider/auth_provider.dart';
import 'package:electrio/provider/booking_provider.dart';
import 'package:electrio/provider/user_provider.dart';
import 'package:electrio/view/profile_sscreen.dart';
import 'package:electrio/view/signup/forget_password.dart';
import 'package:electrio/view/home_screen.dart';
import 'package:electrio/view/signup/loginpage.dart';
import 'package:electrio/view/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(), 
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BookingProvider(),
        ),
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          // '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
          '/forgetPassword': (context) => const ForgetPasswordPage(),
          '/': (context) => HomeScreen(),
          '/profile': (context) => ProfileScreen(),
        },
      ),
    );
  }
}

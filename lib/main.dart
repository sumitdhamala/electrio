import 'package:electrio/provider/auth_provider.dart';
import 'package:electrio/provider/booking_provider.dart';
import 'package:electrio/provider/user_provider.dart';
import 'package:electrio/provider/vehicle_provider.dart';
import 'package:electrio/view/settings/profile_sscreen.dart';
import 'package:electrio/view/signup/forget_password.dart';
import 'package:electrio/view/home_screen.dart';
import 'package:electrio/view/signup/loginpage.dart';
import 'package:electrio/view/signup/signup.dart';
import 'package:electrio/view/signup/vehicle_registration.dart';
import 'package:electrio/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.loadToken();
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
        ChangeNotifierProvider(
          create: (_) => VehicleProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/forgetPassword': (context) => ForgetPasswordPage(),
          '/home': (context) => HomeScreen(),
          '/profile': (context) => ProfileScreen(),
          '/vehicleRegistration': (context) => VehicleRegistrationPage(),
        },
      ),
    );
  }
}

import 'package:electrio/provider/auth_provider.dart';
import 'package:electrio/provider/booking_provider.dart';
import 'package:electrio/provider/reservationprovider.dart';
import 'package:electrio/provider/user_provider.dart';
import 'package:electrio/provider/vehicle_provider.dart';
import 'package:electrio/view/settings/profile_sscreen.dart';
import 'package:electrio/view/signup/forget_password.dart';
import 'package:electrio/view/home_screen.dart';
import 'package:electrio/view/signup/loginpage.dart';
import 'package:electrio/view/signup/signup.dart';
import 'package:electrio/view/signup/vehicle_registration.dart';
import 'package:electrio/view/splash_screen.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart'; // Import overlay_support package

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
    return OverlaySupport.global(
      // Ensure OverlaySupport.global is wrapping your app
      child: MultiProvider(
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
            create: (_) => Reservationprovider(),
          ),
          ChangeNotifierProvider(
            create: (_) => VehicleProvider(),
          ),
        ],
        child: KhaltiScope(
          publicKey: "9f74423ecb2f4131aef333d24d65a04e",
          builder: (context, navigatorKey) {
            return MaterialApp(
              theme: ThemeData(
                appBarTheme: AppBarTheme(
                  iconTheme: IconThemeData(color: Colors.white),
                ),
                snackBarTheme: SnackBarThemeData(
                  backgroundColor: Colors.green,
                  contentTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('ne', 'NP'),
              ],
              localizationsDelegates: [
                KhaltiLocalizations.delegate,
              ],
              routes: {
                '/': (context) => SplashScreen(),
                '/login': (context) => LoginPage(),
                '/signup': (context) => SignupPage(),
                '/forgetPassword': (context) => ForgetPasswordPage(),
                '/home': (context) => HomeScreen(),
                '/profile': (context) => ProfileScreen(),
                '/vehicleRegistration': (context) => VehicleRegistrationPage(),
              },
            );
          },
        ),
      ),
    );
  }
}

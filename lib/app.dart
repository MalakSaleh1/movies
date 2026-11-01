import 'package:flutter/material.dart';

import 'modules/auth/view/screens/login_screen.dart';
import 'modules/auth/view/screens/register_screen.dart';
import 'modules/auth/view/screens/reset_password_screen.dart';
import 'modules/splash/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        ResetPasswordScreen.routeName: (_) => const ResetPasswordScreen(),
      },
    );
  }
}

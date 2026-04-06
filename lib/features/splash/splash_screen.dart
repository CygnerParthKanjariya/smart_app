import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_grocery/features/product/screen/product_screen.dart';

import '../login/screen/login_screen.dart';
import '../settings/bloc/settings_bloc.dart';
import '../settings/bloc/settings_event.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(LoadThemeEvent());

    final user = FirebaseAuth.instance.currentUser;

    Future.delayed(Duration(seconds: 3), () {
      if (user == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ProductScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Smart App",
          style: TextStyle(fontSize: 50, color: Colors.red),
        ),
      ),
    );
  }
}

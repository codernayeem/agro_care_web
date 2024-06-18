import 'package:agro_care_web/colors.dart';
import 'package:agro_care_web/providers/agri_data_provider.dart';
import 'package:agro_care_web/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void startChecking() {
    Future.delayed(const Duration(milliseconds: 900)).then((value) {
      MyAuthProvider authProvider = context.read();
      authProvider.initialize();
      context.read<AgriDataProvider>().updateCredential(authProvider.email);
      if (authProvider.isLoggedIn()) {
        Navigator.pushReplacementNamed(context, "dashBoardPage");
      } else {
        Navigator.pushReplacementNamed(context, "signUpPage");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startChecking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: "top_bar",
        child: Container(
          color: bgSplash,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icon_128.png",
                width: 86,
              ),
              const SizedBox(height: 10),
              const Material(
                type: MaterialType.transparency,
                child: Text(
                  'Agro Care',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              const Material(
                type: MaterialType.transparency,
                child: Text(
                  'Admin Panel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

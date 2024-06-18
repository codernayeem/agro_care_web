import 'package:agro_care_web/firebase_options.dart';
import 'package:agro_care_web/providers/agri_data_provider.dart';
import 'package:agro_care_web/providers/auth_provider.dart';
import 'package:agro_care_web/providers/users_data_provider.dart';
import 'package:agro_care_web/screens/dashboard_page.dart';
import 'package:agro_care_web/screens/sign_in_page.dart';
import 'package:agro_care_web/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/settings_provider.dart';
import 'providers/predictions_provider.dart';
import 'providers/statictics_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseFirestore.instance.settings = const Settings(
  //   persistenceEnabled: true,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAuthProvider>(
            create: (context) => MyAuthProvider()),
        ChangeNotifierProvider<AgriDataProvider>(
            create: (context) => AgriDataProvider()),
        ChangeNotifierProvider<UsersDataProvider>(
            create: (context) => UsersDataProvider()),
        ChangeNotifierProvider<SettingsProvider>(
            create: (context) => SettingsProvider()),
        ChangeNotifierProvider<PredictionsProvider>(
            create: (context) => PredictionsProvider()),
        ChangeNotifierProvider<StaticticsProvider>(
            create: (context) => StaticticsProvider()),
      ],
      child: MaterialApp(
        title: 'Agro Care Admin Panel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF579133)),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        // home: RichTextEditPage(text: "", onSaveClick: (htmlText) {}),
        routes: {
          "signUpPage": (context) => const SignUpPage(),
          "dashBoardPage": (context) => const DashBoardPage(),
        },
      ),
    );
  }
}

import 'package:agro_care_web/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/users_data_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  MyAuthProvider? authProvider;

  void onLogout(BuildContext context) {
    authProvider!.logout().then((value) {
      Navigator.pushNamedAndRemoveUntil(
          context, "signUpPage", (route) => false);
    });
  }

  // String data = "";

  bool load = false;
  UsersDataProvider? uss;

  // void getData(UsersDataProvider uss) async {
  //   if (load) return;
  //   load = true;
  //   data = await uss.testFuture();
  //   load = false;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    authProvider ??= context.read<MyAuthProvider>();

    uss ??= context.watch();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/icon_128.png",
                  width: 84,
                ),
                const SizedBox(height: 10),
                Text(
                  'Admin',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    onLogout(context);
                  },
                  child: const Text("Logout"),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     getData(uss!);
                //   },
                //   child: const Text("Test"),
                // ),
                // Padding(
                //   padding: EdgeInsets.all(16),
                //   child: SelectableText(data),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

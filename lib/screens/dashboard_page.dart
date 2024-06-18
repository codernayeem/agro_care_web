import 'package:agro_care_web/colors.dart';
import 'package:agro_care_web/providers/auth_provider.dart';
import 'package:agro_care_web/screens/settings_page.dart';
import 'package:agro_care_web/screens/predictions_page.dart';
import 'package:agro_care_web/screens/profile_page.dart';
import 'package:agro_care_web/screens/statictics_page.dart';
import 'package:agro_care_web/screens/users_home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage>
    with SingleTickerProviderStateMixin {
  int selectedPage = 0;

  final pages = [
    const UsersHomePage(key: ValueKey("UsersHomePage")),
    const SettingsPage(key: ValueKey("CropDetailsPage")),
    const PredictionsViewPage(key: ValueKey("PredictionsViewPage")),
    const StaticticsPage(key: ValueKey("StaticticsPage")),
    const ProfilePage(key: ValueKey("ProfilePage")),
  ];

  onClick(int index) {
    if (selectedPage == index) return;

    setState(() {
      selectedPage = index;
    });
  }

  @override
  void initState() {
    super.initState();
    MyAuthProvider authProvider = context.read<MyAuthProvider>();
    if (!authProvider.isLoggedIn()) {
      Navigator.pushReplacementNamed(context, "signUpPage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.deviceScreenType == DeviceScreenType.tablet ||
            sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Agro Care Admin Panel"),
            ),
            body: pages[selectedPage],
            drawer: getSideView(),
          );
        }
        return Scaffold(
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getSideView(),
              Expanded(
                child: pages[selectedPage],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getSideView() {
    return Container(
      color: Colors.green[100],
      width: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset(
                "assets/icon_128.png",
                width: 50,
              ),
              const Text(
                'Agro Care Admin Panel',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),
          getNavItem(
            0,
            "Our App Users",
            "View phone numbers",
            Icons.person_search_rounded,
          ),
          getNavItem(
            1,
            "Settings",
            "View Diseases & more",
            Icons.settings,
          ),
          getNavItem(
            2,
            "Predictions",
            "Check out the predictions",
            Icons.bar_chart_rounded,
          ),
          getNavItem(
            3,
            "Statictics",
            null,
            Icons.pie_chart_rounded,
          ),
          getNavItem(
            4,
            "Profile",
            null,
            Icons.admin_panel_settings_outlined,
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget getNavItem(int index, String title, String? subTitle, IconData ic) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        onTap: () => onClick(index),
        selected: index == selectedPage,
        selectedTileColor: bgSplash.withOpacity(.1),
        splashColor: bgSplash.withOpacity(.3),
        leading: Icon(
          ic,
          color: bgSplash,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: subTitle != null ? Text(subTitle) : null,
        trailing: const Icon(
          Icons.navigate_next_rounded,
          color: bgSplash,
        ),
      ),
    );
  }
}

import 'package:agro_care_web/providers/users_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersHomePage extends StatefulWidget {
  const UsersHomePage({super.key});

  @override
  State<UsersHomePage> createState() => _UsersHomePageState();
}

class _UsersHomePageState extends State<UsersHomePage> {
  UsersDataProvider? usersDataProvider;

  void onReload() {
    usersDataProvider!.usersData = [];
    usersDataProvider!.databaseLoaded = false;
    setState(() {});
  }

  Widget showUsersInfo() {
    if (usersDataProvider!.databaseLoaded) {
      return PaginatedDataTable(
        header: Row(
          children: [
            const Text('Users List'),
            const Spacer(),
            IconButton.filledTonal(
              onPressed: onReload,
              icon: const Icon(Icons.replay_rounded),
            )
          ],
        ),
        columns: const [
          DataColumn(
            label: Text(
              'No.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'User Phone Number',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        source: UsersDataSource(items: usersDataProvider!.usersData),
      );
    } else {
      usersDataProvider!.checkForUpdate();
      return const Padding(
        padding: EdgeInsets.only(top: 100),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    usersDataProvider ??= context.watch();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Some details about users of Agro Care App',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                    child: SelectionArea(child: showUsersInfo()))),
          ],
        ),
      ),
    );
  }
}

class UsersDataSource extends DataTableSource {
  final List<UserData> items;

  UsersDataSource({required this.items});

  @override
  DataRow? getRow(int index) {
    if (index >= items.length) {
      return null;
    }
    final item = items[index];
    return DataRow(cells: [
      DataCell(Text((index + 1).toString())),
      DataCell(Text(item.phone)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => items.length;

  @override
  int get selectedRowCount => 0;
}

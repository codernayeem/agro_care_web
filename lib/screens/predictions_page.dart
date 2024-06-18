import 'package:agro_care_web/providers/predictions_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PredictionsViewPage extends StatefulWidget {
  const PredictionsViewPage({super.key});

  @override
  State<PredictionsViewPage> createState() => _PredictionsViewPageState();
}

class _PredictionsViewPageState extends State<PredictionsViewPage> {
  PredictionsProvider? provider;

  void onReload() {
    provider!.data = [];
    provider!.databaseLoaded = false;
    setState(() {});
  }

  void onClickImageId(String imageId) async {
    try {
      var link = await FirebaseStorage.instance
          .ref("predicted_imgs_v2/$imageId.jpg")
          .getDownloadURL();

      launchUrl(Uri.parse(link));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "This image was not saved! Sorry!",
          ),
        ),
      );
      return;
    }
  }

  Widget showPredictions() {
    if (provider!.databaseLoaded) {
      return PaginatedDataTable(
        header: Row(
          children: [
            const Text('Predictions List'),
            const Spacer(),
            IconButton.filledTonal(
              onPressed: onReload,
              icon: const Icon(Icons.replay_rounded),
            )
          ],
        ),
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('User')),
          DataColumn(label: Text('DateTime')),
          DataColumn(label: Text('Identified')),
          DataColumn(label: Text('Plant')),
          DataColumn(label: Text('Leaf')),
          DataColumn(label: Text('Label')),
          DataColumn(label: Text('Healthy')),
          DataColumn(label: Text('Confidence')),
          DataColumn(label: Text('imageId')),
        ],
        source: PredictionsSource(
            items: provider!.data, onClickImageId: onClickImageId),
      );
    } else {
      provider!.checkForUpdate();
      return const Column(
        children: [
          SizedBox(height: 100),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    provider ??= context.watch();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SelectionArea(
                  child: showPredictions(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PredictionsSource extends DataTableSource {
  final List<Map<String, dynamic>> items;
  void Function(String imageId) onClickImageId;

  PredictionsSource({required this.items, required this.onClickImageId});

  final f = DateFormat('yyyy-MM-dd hh:mm');

  @override
  DataRow? getRow(int index) {
    if (index >= items.length) {
      return null;
    }
    final item = items[index];
    return DataRow(cells: [
      DataCell(Text((index + 1).toString())),
      DataCell(Text((item['email'] as String)
          .replaceFirst("agro.", '')
          .replaceFirst("@care.bd", ''))),
      DataCell(Text(f.format(
          DateTime.fromMillisecondsSinceEpoch(item['dateTime_user'] as int)))),
      DataCell(Checkbox(onChanged: (value) {}, value: item['identified'])),
      DataCell(Text(item['plantName'])),
      DataCell(
          Checkbox(onChanged: (value) {}, value: item['label'] != "non_leaf")),
      DataCell(Text(item['label'])),
      DataCell(Checkbox(onChanged: (value) {}, value: item['isHealthy'])),
      DataCell(Text(item['confidence'].toString())),
      DataCell(TextButton(
        child: Text(item['imageId']),
        onPressed: () {
          onClickImageId(item['imageId']);
        },
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => items.length;

  @override
  int get selectedRowCount => 0;
}

import 'package:agro_care_web/providers/settings_provider.dart';
import 'package:agro_care_web/screens/text_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart' show parse;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsProvider? provider;

  TextEditingController? _controller;

  void onReload() {
    provider!.data = null;
    provider!.databaseLoaded = false;
    setState(() {});
  }

  void onClickSaveCallNumber() {
    var text = _controller!.text.trim();

    provider!.update("call_number", text);
    Navigator.pop(context);
  }

  void onClickSaveDiseaseName(String plantDetailsId, String diseaselabel) {
    var text = _controller!.text.trim();

    var d = provider!.data![plantDetailsId];
    d[diseaselabel]['diseaseName'] = text;

    provider!.update(plantDetailsId, d);
    Navigator.pop(context);
  }

  void onClickSaveDiseaseDetails(
      String plantDetailsId, String diseaselabel, String htmlText) {
    var d = provider!.data![plantDetailsId];
    d[diseaselabel]['details'] = htmlText;

    provider!.update(plantDetailsId, d);
    Navigator.pop(context);
  }

  void onClickDiseaseDetails(
      String plantDetailsId, String diseaselabel, String diseaseName) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: RichTextEditPage(
            title: "Details of $diseaseName",
            text: provider!.data![plantDetailsId][diseaselabel]['details'],
            onSaveClick: (htmlText) {
              onClickSaveDiseaseDetails(plantDetailsId, diseaselabel, htmlText);
            },
            onCancelClick: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void onClickEditDisease(String plantDetailsId, String diseaselabel) {
    showBottomTextEditor(
      "Disease Name",
      provider!.data![plantDetailsId][diseaselabel]['diseaseName'],
      () {
        onClickSaveDiseaseName(plantDetailsId, diseaselabel);
      },
    );
  }

  void onClickCallNumber() {
    showBottomTextEditor(
      "Helping Phone Number",
      provider!.data!['call_number'],
      onClickSaveCallNumber,
    );
  }

  void showBottomTextEditor(String label, String text, void Function() onSave) {
    _controller ??= TextEditingController();
    _controller!.text = text;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.green,
                        width: 1,
                      ),
                    ),
                    helperText: label,
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              FloatingActionButton(
                onPressed: onSave,
                child: const Icon(Icons.done),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget showDiseaseDetailsList(String plantId) {
    var detailsMap = (provider!.data!['details_$plantId'] as Map);
    var detailsKey = (provider!.data!['labels_$plantId'] as List);

    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        constraints: const BoxConstraints(maxHeight: 500, minHeight: 300),
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          addRepaintBoundaries: false,
          addAutomaticKeepAlives: false,
          itemCount: detailsKey.length,
          itemBuilder: (context, index) {
            Map d = detailsMap[detailsKey[index]];
            bool h = d['isHealthy'];

            if (h) return const SizedBox(height: 0, width: 0);

            String? subTitle;
            subTitle = parse(d['details']).body?.text;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  onTap: () {
                    onClickDiseaseDetails("details_$plantId", detailsKey[index],
                        d['diseaseName']);
                  },
                  title: Text(d['diseaseName']),
                  subtitle: subTitle != null
                      ? Text(
                          subTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : const Text("Click to add Details"),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      onClickEditDisease("details_$plantId", detailsKey[index]);
                    },
                  )),
            );
          },
        ),
      ),
    );
  }

  Widget showSettings() {
    if (provider!.databaseLoaded) {
      var data = provider!.data;

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.grey, width: 1),
              ),
              onTap: () {},
              title: const Text("Under Maintanence"),
              subtitle: const Text("Currently not changable"),
              trailing: Checkbox(
                value: data!['under_maintenance'],
                onChanged: (value) {},
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.grey, width: 1),
                ),
                onTap: onClickCallNumber,
                title: const Text("Help Number"),
                subtitle: Text(data['call_number']),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onClickCallNumber,
                )),
            const SizedBox(height: 20),
            const Text(
              "Details of Tomato Disease",
              style: TextStyle(
                fontFamily: "Lexend",
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            showDiseaseDetailsList('tomato'),
            const SizedBox(height: 20),
            const Text(
              "Details of Potato Disease",
              style: TextStyle(
                fontFamily: "Lexend",
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            showDiseaseDetailsList('potato'),
            const SizedBox(height: 20),
            const Text(
              "Details of Corn Disease",
              style: TextStyle(
                fontFamily: "Lexend",
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            showDiseaseDetailsList('corn'),
            const SizedBox(height: 40),
          ],
        ),
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
      appBar: AppBar(
          title: const Text(
            "Settings",
            style: TextStyle(
              fontFamily: "Lexend",
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: (provider!.databaseLoaded)
              ? [
                  IconButton.filledTonal(
                    onPressed: onReload,
                    icon: const Icon(Icons.replay_rounded),
                  ),
                  const SizedBox(width: 16),
                ]
              : null,
          automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: showSettings(),
      ),
    );
  }
}

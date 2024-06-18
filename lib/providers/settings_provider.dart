import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsProvider with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Map<String, dynamic>? data;
  bool databaseLoaded = false;

  Future<void> checkForUpdate() async {
    try {
      var doc = await fireStore.collection("settings").doc("info_v2").get();
      if (doc.exists) {
        data = doc.data();
      }
      databaseLoaded = true;
    } catch (e) {
      print("Error occured: $e");
      databaseLoaded = true;
    }
    notifyListeners();
  }

  void update(String key, dynamic val) async {
    data![key] = val;
    await fireStore.collection("settings").doc("info_v2").update({key: val});
    notifyListeners();
  }
}

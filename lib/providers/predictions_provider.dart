import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PredictionsProvider with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> data = [];
  bool databaseLoaded = false;

  Future<void> checkForUpdate() async {
    try {
      var docs = await fireStore.collection("predictions_v2").get();
      data.clear();
      for (var doc in docs.docs) {
        data.add(doc.data());
      }
      data.sort(
        (a, b) =>
            (b['dateTime_user'] as int).compareTo((a['dateTime_user'] as int)),
      );
      databaseLoaded = true;
    } catch (e) {
      print("Error occured");
    }
    notifyListeners();
  }
}

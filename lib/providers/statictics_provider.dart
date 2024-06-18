import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaticticsProvider with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  bool databaseLoaded = false;

  int totalUser = 0;
  Map<String, double> selectedCrops = {};
  Map<String, double> selectedOptions = {};

  Future<void> checkForUpdate() async {
    try {
      var docs = await fireStore.collection("user_data").get();

      totalUser = 0;
      selectedCrops.clear();
      selectedOptions.clear();

      for (var doc in docs.docs) {
        totalUser += 1;
        var d = doc.data();
        var d1 = (d['selected_crops'] as List?) ?? [];
        for (var element in d1) {
          selectedCrops[element] = (selectedCrops[element] ?? 0) + 1;
        }
        var d2 = (d['selected_options'] as List?) ?? [];
        for (var element in d2) {
          selectedOptions[element] = (selectedOptions[element] ?? 0) + 1;
        }
      }
      databaseLoaded = true;
    } catch (e) {
      print("Error occured: $e");
      databaseLoaded = true;
    }
    notifyListeners();
  }
}

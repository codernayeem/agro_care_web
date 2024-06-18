import 'package:agro_care_web/models/agri_options_model.dart';
import 'package:agro_care_web/models/select_crop_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AgriDataProvider with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String email = "";
  bool databaseLoaded = false;

  List<MyAgriOption> myAgriOptions = [
    MyAgriOption("op-1", "আমি মাঠে ফসল ফলাই", false),
    MyAgriOption("op-2", "আমি বাড়ির বাগানে ফসল ফলাই", false),
    MyAgriOption("op-3", "আমি টবে ফসল ফলাই", false),
  ];

  List<Crop> myCrops = [
    Crop("tomato", "Tomato", "টমেটো", "assets/tomato.png", false),
    Crop("potato", "Potato", "আলু", "assets/potato.png", false),
    Crop("corn", "Corn", "ভুট্টা", "assets/corn.png", false),
    Crop("cucumber", "Cucumber", "শশা", "assets/cucumber.png", false),
    Crop("onion", "Onion", "পেঁয়াজ", "assets/onion.png", false),
    Crop("red_chili", "Red Chili", "মরিচ", "assets/red_chili.png", false),
    Crop("eggplant", "Eggplant", "বেগুন", "assets/eggplant.png", false),
    Crop("pumpkin", "Pumpkin", "মিষ্টি কুমড়া", "assets/pumpkin.png", false),
  ];

  void updateCredential(String email) {
    this.email = email;
  }

  bool checkCredential() {
    return email.isNotEmpty;
  }

  void _saveSelection(
      {List<String>? selectedCropIdList, List<String>? selectedOptionIdList}) {
    // for crops
    int i;

    if (selectedCropIdList != null) {
      for (i = 0; i < myCrops.length; i++) {
        if (selectedCropIdList.contains(myCrops[i].id)) {
          myCrops[i].selected = true;
        } else {
          myCrops[i].selected = false;
        }
      }
    }
    // for agri options
    if (selectedOptionIdList != null) {
      for (i = 0; i < myAgriOptions.length; i++) {
        if (selectedOptionIdList.contains(myAgriOptions[i].id)) {
          myAgriOptions[i].selected = true;
        } else {
          myAgriOptions[i].selected = false;
        }
      }
    }
  }

  Future<void> checkForUpdate() async {
    // Don't check if the database is already loaded
    if (databaseLoaded) return;

    var data = await fireStore.collection("user_data").doc(email).get();
    if (!data.exists) {
      _saveSelection(selectedCropIdList: [], selectedOptionIdList: []);
    } else {
      _saveSelection(
        selectedCropIdList: data["selected_crops"],
        selectedOptionIdList: data["selected_options"],
      );
    }
    databaseLoaded = true;
    notifyListeners();
  }

  Future<void> saveSelectionData(
      {List<String>? selectedCropIdList,
      List<String>? selectedOptionIdList}) async {
    Map<String, Object?> data = {};

    // remove in production
    if (!checkCredential()) {
      print("Error Occured in AgriDataProvider");
      return;
    }

    if (selectedCropIdList != null) {
      data["selected_crops"] = selectedCropIdList;
    }
    if (selectedCropIdList != null) {
      data["selected_options"] = selectedOptionIdList;
    }
    try {
      await fireStore
          .collection("user_data")
          .doc(email)
          .set(data, SetOptions(merge: true));
      _saveSelection(
        selectedCropIdList: selectedCropIdList,
        selectedOptionIdList: selectedOptionIdList,
      );
      databaseLoaded = true;
    } catch (e) {
      print("Error AgriDataProvider: $e");
    }
    notifyListeners();
  }

  List<Crop> getSelectedCrops() {
    return myCrops.where((element) => element.selected).toList();
  }
}

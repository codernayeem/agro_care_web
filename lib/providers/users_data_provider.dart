import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersDataProvider with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  List<UserData> usersData = [];
  bool databaseLoaded = false;

  Future<void> checkForUpdate() async {
    try {
      var data = await fireStore.collection("user_list").get();
      usersData.clear();
      for (var doc in data.docs) {
        usersData.add(UserData(
          doc.id,
          "",
          doc.get("email"),
          doc.get("phone_num"),
        ));
      }
      databaseLoaded = true;
    } catch (e) {
      print("Error occured");
    }
    notifyListeners();
  }

  // Future<String> testFuture() async {
  //   try {
  //     var data = await fireStore.collection("predictions").get();
  //     List<Map> l = [];
  //     for (var element in data.docs) {
  //       var m = {
  //         "dateTime": (element["dateTime"] as Timestamp).toDate().toString(),
  //         "confidence": element["confidence"] as double,
  //         "identified": element["identified"] as bool,
  //         "label": element["label"] as String,
  //         "isHealthy": element["isHealthy"] as bool,
  //         "plantName": element["plantName"] as String,
  //         "diseaseName": element["diseaseName"] as String,
  //         "imageId": element["imageId"] as String,
  //       };
  //       l.add(m);
  //     }

  //     return jsonEncode(l);
  //   } catch (e) {
  //     return "$e";
  //   }
  // }

  Future<String> testFuture() async {
    try {
      // var doc = await fireStore.collection("settings").doc("info").get();
      // var data = doc.data();
      // var jsonData = jsonEncode(data);
      // Clipboard.setData(ClipboardData(text: jsonData));

      // Map<String, dynamic> data = jsonDecode(SAMPLE);

      // var doc = await fireStore.collection("settings").doc("info_v2").set(data);

      // return data.toString();
      return "OK";
    } catch (e) {
      return "$e";
    }
  }
}

class UserData {
  late String id;
  late String name;
  late String email;
  late String phone;

  UserData.empty() {
    id = "";
    name = "";
    email = "";
    phone = "";
  }

  UserData(this.id, this.name, this.email, this.phone);
}

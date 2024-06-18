import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Status { AUTH_SUCCESS, AUTH_FAILED }

class MyAuthProvider with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  String email = "";

  void initialize() {
    if (auth.currentUser != null && auth.currentUser!.email != null) {
      email = auth.currentUser!.email!;
    }
  }

  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  Future<Status> trySignIn(String user, String pass) async {
    user = "$user@admin.com";
    try {
      await auth.signInWithEmailAndPassword(email: user, password: pass);
      initialize();
      return Status.AUTH_SUCCESS;
    } catch (e) {
      // print("Auth Error : $e");
      return Status.AUTH_FAILED;
    }
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  Future<Status> createNewUser(String user, String pass) async {
    try {
      user = "$user@admin.com";
      await auth.createUserWithEmailAndPassword(email: user, password: pass);
      initialize();
      return Status.AUTH_SUCCESS;
    } catch (e) {
      // print("Auth Error : $e");
      return Status.AUTH_FAILED;
    }
  }
}

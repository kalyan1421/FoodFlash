import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:uber_eats/model/user.dart' as model;

class Authmethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User?> getUserDetails() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (snap.exists) {
        return model.User.fromSnap(snap);
      }
    }
    return null;
  }

  // ignore: non_constant_identifier_names
  Future<String> SignupUser(
      {required String email,
      required String password,
      required String username}) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        //Register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (kDebugMode) {
          print(cred.user!.uid);
        }

        model.User user =
            model.User(email: email, uid: cred.user!.uid, username: username);
        _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = "Success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "some Erorr occues";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'Success';
      } else {
        res = "Please entre all the fileds";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coderstatus/components/generalLoader.dart';
import 'package:coderstatus/getStartedScreen.dart';
import 'package:coderstatus/homeScreen.dart';
import 'package:coderstatus/registerNameScreen.dart';
import 'package:coderstatus/verifyEmailScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool flag = false;

  Future updateFlag() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser.uid)
          .get()
          .then((doc) {
        flag = doc.exists;
      });
    } catch (e) {
      flag = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: updateFlag(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (_auth.currentUser != null) {
            if (_auth.currentUser.emailVerified) {
              if (flag) {
                return HomeScreen();
              } else {
                return Registernamescreen();
              }
            } else {
              return VerifyEmailScreen();
            }
          } else {
            return GetStartedScreen();
          }
        } else {
          return GeneralLoader('');
        }
      },
    );
  }
}

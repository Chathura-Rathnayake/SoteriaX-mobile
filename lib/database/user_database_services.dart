

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soteriax/models/lifeguard.dart';

class UserDatabaseService{
  final CollectionReference lifeguards=FirebaseFirestore.instance.collection("lifeguards");
  UserDatabaseService({this.userId});
  String? userId;
  Future<SharedPreferences> _pref=SharedPreferences.getInstance();

  void getUserData() async{
    final SharedPreferences prefs=await _pref;
    lifeguards.doc(userId).get().then((DocumentSnapshot documentSnapshot){
      if(documentSnapshot.exists){
        print(documentSnapshot.data());
        Lifeguard lifeguard =Lifeguard(
            uid: userId,
            firstname: documentSnapshot.get("firstName"),
            lastname: documentSnapshot.get("lastName"),
            email: documentSnapshot.get("email"),
            certificateLevel: documentSnapshot.get("certificateLevel"),
            noOfOperations: documentSnapshot.get("noOfOperations"),
            isPilot: documentSnapshot.get("isPilot"),
            birthDate: documentSnapshot.get("birthDate")
        );
         prefs.setString("lifeguardData", lifeguard.toString());
         print(lifeguard.toString());
      }else{
        print("Document doesn't exist sorry");
      }
    });
  }
}
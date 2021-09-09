

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soteriax/models/lifeguard.dart';

class UserDatabaseService{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final CollectionReference lifeguards=FirebaseFirestore.instance.collection("lifeguards");
  final CollectionReference headLifeguards=FirebaseFirestore.instance.collection("headLifeguards");
  UserDatabaseService({this.userId});
  String? userId;
  Future<SharedPreferences> _pref=SharedPreferences.getInstance();

  void getLifeguardData() async{
    final SharedPreferences prefs=await _pref;
    await lifeguards.doc(userId).get().then((DocumentSnapshot documentSnapshot) async {
      if(documentSnapshot.exists){
        print(documentSnapshot.data());
        Company company=await getCompanyDetails(documentSnapshot.get("companyID")!);
        // Company company=new Company(companyId: documentSnapshot.get("id"), companyEmail: documentSnapshot.get("companyName"),
        // companyAddress: documentSnapshot.get("companyAddress"), companyName: documentSnapshot.get("companyName"));
        Lifeguard lifeguard =Lifeguard(
            uid: userId,
            firstname: documentSnapshot.get("firstName"),
            lastname: documentSnapshot.get("lastName"),
            email: documentSnapshot.get("email"),
            nic: documentSnapshot.get('NIC'),
            mobileNo: documentSnapshot.get('phone_number'),
            certificateLevel: documentSnapshot.get("certificateLevel"),
            birthDate: documentSnapshot.get("birthDate"),
            designation: "Lifeguard",
            company: company
        );
         prefs.setString("lifeguardData", lifeguard.toString());
         print("lifeguardData:  ${lifeguard.toString()}");
      }else{
        print("Document doesn't exist sorry");
      }
    });
  }

  void getHeadLifeguardData() async{
    final SharedPreferences prefs=await _pref;
    await headLifeguards.doc(userId).get().then((DocumentSnapshot documentSnapshot) async {
      if(documentSnapshot.exists){
        print(documentSnapshot.data());
        Company company=await getCompanyDetails(userId!);
        Lifeguard lifeguard =Lifeguard(
            uid: userId,
            firstname: documentSnapshot.get("firstName"),
            lastname: documentSnapshot.get("lastName"),
            email: documentSnapshot.get("userEmail"),
            birthDate: documentSnapshot.get("birthday"),
            company: company,
            designation: "Head Lifeguard"
        );
        prefs.setString("lifeguardData", lifeguard.toString());
        print("headLifeguardData:  ${lifeguard.toString()}");
      }else{
        print("Document doesn't exist sorry");
      }
    });
  }
  
  Future<bool> checkLifeguard(String email) async{
    bool isLifeguard=await lifeguards.where("email", isEqualTo: email).get().then((QuerySnapshot snapshot){
      if(snapshot.size==0){
        return false;
      }else{
        return true;
      }
    });
    return isLifeguard;
  }

  Future<bool> checkHeadLifeguard(String email) async{
    bool isLifeguard=await headLifeguards.where("userEmail", isEqualTo: email).get().then((QuerySnapshot snapshot){
      if(snapshot.size==0){
        return false;
      }else{
        return true;
      }
    });
    return isLifeguard;
  }

  Future<Company> getCompanyDetails(String id) async{
    Company company=await headLifeguards.doc(id).get().then((DocumentSnapshot snapshot){
      if(snapshot.exists){
        return Company(companyName: snapshot.get("companyName"), companyEmail: snapshot.get("companyEmail"),
          companyAddress: snapshot.get("companyAddress"), companyId: id);
      }else{
        return Company();
      }
    });
    
    return company;
  }
}
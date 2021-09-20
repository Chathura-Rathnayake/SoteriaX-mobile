
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';

class GetComplaintDB{
  CollectionReference complaints=FirebaseFirestore.instance.collection('complaints');
  LifeguardSingleton lifeguardSingleton=LifeguardSingleton();

  Stream<QuerySnapshot?> get getAllComplaints{
    //print('comp: ${lifeguardSingleton.company.companyId}, user: ${lifeguardSingleton.uid}');
    print(complaints.where('companyID', isEqualTo: lifeguardSingleton.company.companyId).
    where("userID", isEqualTo: lifeguardSingleton.uid).snapshots());
    return complaints.where('companyID', isEqualTo: lifeguardSingleton.company.companyId).
    where("name", isEqualTo: '${lifeguardSingleton.firstname} ${lifeguardSingleton.lastname}')
        .orderBy('date').snapshots();
  }









}
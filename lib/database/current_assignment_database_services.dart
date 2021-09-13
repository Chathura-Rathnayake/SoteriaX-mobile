
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';

class CurrentAssignmentDB{
  CollectionReference trainingOperations=FirebaseFirestore.instance.collection('trainingOperations');
  LifeguardSingleton lifeguardSingleton=LifeguardSingleton();

  Stream<QuerySnapshot?> get getCurrentAssignments{
    print('comp: ${lifeguardSingleton.company.companyId}, user: ${lifeguardSingleton.uid}');
    return trainingOperations.where('companyID', isEqualTo: lifeguardSingleton.company.companyId).
      where("participantIDs", arrayContains: lifeguardSingleton.uid).where('operationStatus', isEqualTo: 'Pending')
        .orderBy('dateTime').snapshots();
  }

  Future<DocumentSnapshot?> getLatestAssignment() async{
    DocumentSnapshot? latestAssignment=await trainingOperations.where('companyID', isEqualTo: lifeguardSingleton.company.companyId).
    where("participantIDs", arrayContains: lifeguardSingleton.uid).where('operationStatus', isEqualTo: 'Pending')
        .orderBy('dateTime').get().then((snap){
           if(snap.size>0){
             return snap.docs[0];
           }else{
             return null;
           }
    });

    return latestAssignment;
  }








}
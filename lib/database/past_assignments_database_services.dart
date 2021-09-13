import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';

class PastAssignmentDB{
  CollectionReference trainingOperations=FirebaseFirestore.instance.collection('trainingOperations');
  LifeguardSingleton lifeguardSingleton=LifeguardSingleton();

  Stream<QuerySnapshot?> get getPastAssignments{
    print('comp: ${lifeguardSingleton.company.companyId}, user: ${lifeguardSingleton.uid}');
    return trainingOperations.where('companyID', isEqualTo: lifeguardSingleton.company.companyId).
    where("participantIDs", arrayContains: lifeguardSingleton.uid).where('operationStatus', isEqualTo: 'ended')
        .orderBy('dateTime').snapshots();
  }

}
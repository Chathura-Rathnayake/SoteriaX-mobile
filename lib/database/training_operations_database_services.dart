import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';

class TrainingOperationsDBServices{
  LifeguardSingleton lifeguardSingleton=LifeguardSingleton();
  String? companyId;
  String? operationId;

  CollectionReference headLifeguards=FirebaseFirestore.instance.collection('headLifeguards');

  TrainingOperationsDBServices({this.operationId}){
    companyId=lifeguardSingleton.company.companyId;
  }

  Stream<DocumentSnapshot?> get getRpiStatus{
    return headLifeguards.doc(this.companyId).snapshots();
  }

}
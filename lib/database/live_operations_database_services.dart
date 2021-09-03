import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';

class LiveOperationDBServices{
  LifeguardSingleton lifeguardSingleton=LifeguardSingleton();
  String? companyId;
  String? operationId;

  LiveOperationDBServices({this.operationId}){
    companyId=lifeguardSingleton.company.companyId!;
  }

  final CollectionReference operations=FirebaseFirestore.instance.collection("operations");

  Future<void> pingEngagement() async{
    return operations.doc(operationId).update({'engagementPing': DateTime.now().millisecondsSinceEpoch}).
      then((value) => print("pinged")).catchError((error)=>print("Failed to ping: $error"));
  }

  Future<void> setEngaged() async{
    return operations.doc(operationId).update({'isEngaged': true}).
      then((value) => print('set engaged')).catchError((error)=>print("failed to set engaged: $error"));
  }



}
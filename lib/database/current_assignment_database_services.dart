
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';

class CurrentAssignmentDB{
  CollectionReference trainingOperations=FirebaseFirestore.instance.collection('trainingOperations');
  CollectionReference operations=FirebaseFirestore.instance.collection('operations');
  LifeguardSingleton lifeguardSingleton=LifeguardSingleton();

  Stream<QuerySnapshot?> get getCurrentAssignments{
    return trainingOperations.where('companyID', isEqualTo: lifeguardSingleton.company.companyId).
      where("participantIDs", arrayContains: lifeguardSingleton.uid).where('operationStatus', isEqualTo: 'Pending')
       .where("dateTime", isGreaterThanOrEqualTo: Timestamp.now()).orderBy('dateTime').snapshots();
  }

  Future<DocumentSnapshot?> getLatestAssignment() async{
    DocumentSnapshot? latestAssignment;
    DocumentSnapshot? ongoingLiveAssignment;
    var currDate=DateTime.now();
    var currDateString=DateFormat('yyyy-MM-dd').format(currDate);

    ongoingLiveAssignment=await trainingOperations.where('companyID', isEqualTo: lifeguardSingleton.company.companyId).
      where("participantIDs", arrayContains: lifeguardSingleton.uid).where('operationStatus', isEqualTo: 'live')
        .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.parse('$currDateString 00:00:00.000'))).orderBy('dateTime').get().then((snap){
          if(snap.size==0){
            return null;
          }else{
            return snap.docs[0];
          }
    });

    if(ongoingLiveAssignment==null){
      print('nolive');
      latestAssignment=await trainingOperations.where('companyID', isEqualTo: lifeguardSingleton.company.companyId).
      where("participantIDs", arrayContains: lifeguardSingleton.uid).where('operationStatus', isEqualTo: 'Pending')
          .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.parse('$currDateString 00:00:00.000'))).orderBy('dateTime').get().then((snap){
        if(snap.size>0){
          return snap.docs[0];
        }else{
          return null;
        }
      });
    }else{
      return ongoingLiveAssignment;
    }

    return latestAssignment;
  }
  
  Stream<QuerySnapshot?> get ongoingLiveOperations{
    return operations.where('companyId', isEqualTo: lifeguardSingleton.company.companyId).where('operationStatus', isEqualTo: 'live').snapshots();
  }








}
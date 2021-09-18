import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';

class OperationDatabaseService{
  LifeguardSingleton lifeguardSingleton=LifeguardSingleton();
  String? companyId;
  OperationDatabaseService(){
    companyId=lifeguardSingleton.company.companyId!;
  }

  final _processes = [
    'Mission Initiated',
    'Reached Victim',
    'Rest-Tube Dropped',
    'Lifeguard Reached',
    'Mission Completed',
  ];

  final CollectionReference operations=FirebaseFirestore.instance.collection("operations");
  final CollectionReference headLifeguards=FirebaseFirestore.instance.collection("headLifeguards");

  DateTime now =new DateTime.now();

  Future<String?> addLiveOperation() async{
    bool isEngaged=await operations.where("companyId", isEqualTo: this.companyId).where('operationStatus', isEqualTo: 'live').
    where("engaged", isEqualTo: true).get().then((QuerySnapshot snapshot){
      if(snapshot.size==0){
        return false;
      }else{
        return true;
      }
    });
    if(!isEngaged){
      var docX= await operations.add({
        'companyId': this.companyId,
        'currentStage': 1,
        'currentStatus': _processes[0],
        'date': DateFormat('yMd').format(now),
        'emergencyCode': [],
        'engaged':true,
        'engagedLifeguard': {'userFlag': lifeguardSingleton.designation, 'userId': lifeguardSingleton.uid},
        'engagementPing': Timestamp.now(),
        'operationStatus':'live',
        'startDate': DateFormat('yMd').format(now),
        'startTime': DateFormat('kk:mm:ss').format(now),
        'timeline': [Timestamp.now().millisecondsSinceEpoch,"","","",""],
      }).then((value) =>  value.id)
          .catchError((e) {
        print(e.toString());
        return 'error';
      });
      
      if(docX=="error"){
        return null;
      }else{
        return docX;
      }
    }else{
      print("already engaged");
      return null;
    }
  }



  Future<DocumentSnapshot?> isEngaged() async{
    DocumentSnapshot? operation=await operations.where("companyId", isEqualTo: this.companyId).where("engaged", isEqualTo: true).get().then((QuerySnapshot snapshot){
      if(snapshot.size>0){
        return snapshot.docs[0];
      }else{
        return null;
      }
    });
    return operation;
  }

  Future<bool> checkLiveOperation() async{
    bool isLive=await operations.where("companyId", isEqualTo: this.companyId).where("operationStatus", isEqualTo: "live").get().then((QuerySnapshot querySnapshot){
      if(querySnapshot.size==0){
        return false;
      }else{
        return true;
      }
    });
    return isLive;
  }
  
  Future<Map> getOperation()async{
    Map op={'opId': '', 'status': null, 'engaged': false};
    op=await operations.where('companyId', isEqualTo: this.companyId).
      where('operationStatus', isEqualTo: 'live').get().then((QuerySnapshot querySnapshot){
        Map? temp={'opId': null, 'status': null, 'engaged': false};
        if(querySnapshot.size==0){
          return temp;
        }else{
          temp['opId']=querySnapshot.docs[0].id;
          temp['status']=querySnapshot.docs[0].get('operationStatus');
          temp['engaged']=querySnapshot.docs[0].get('engaged');
          return temp;
        }
    });
    return op;
  } 
  
  Future<bool> checkDisengagement() async{ // will also return if it was disengaged
    bool disEngaged=await operations.where('companyId', isEqualTo: this.companyId).
    where('operationStatus', isEqualTo: 'live').where('engaged', isEqualTo: true).get().then((QuerySnapshot snapshot) async{
      if(snapshot.size>0){
        Timestamp t=snapshot.docs[0].get('engagementPing');
        var pingTime=DateTime.fromMillisecondsSinceEpoch(t.millisecondsSinceEpoch);
        var diff=DateTime.now().difference(pingTime);
        print('Difference in seconds: ${diff.inSeconds}');
        print(snapshot.docs[0].get('engagementPing'));
        if(diff.inSeconds>30){
          bool done=await operations.doc(snapshot.docs[0].id).update({'engaged': false}).
          then((value){
            print('disengaged');
            return true;
          }).catchError((error){
            print(error.toString());
            return false;
          });
          return done;
        }else{
          return false;
        }
      }else{
        return false;
      }
    });
    return disEngaged;
  }
  
  Future<int> getRPILastTimestamp() async{
    int rpiTimeStamp=await headLifeguards.doc(this.companyId).get().then((doc){
      return doc.get('piLastOnlineTime');
    });

    return rpiTimeStamp;
  }


  Stream<DocumentSnapshot> get liveOpData{
    return operations.doc(lifeguardSingleton.company.companyId).snapshots();
  }
  
  Stream<QuerySnapshot> get getLiveOperationData{
    return operations.where('companyId', isEqualTo: this.companyId).where('operationStatus', isEqualTo: 'live').snapshots();
  }





}
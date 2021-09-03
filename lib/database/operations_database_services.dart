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
  final CollectionReference operations=FirebaseFirestore.instance.collection("operations");

  DateTime now =new DateTime.now();


  Future<int> getLiveOperationStatus(String companyId) async{
    int status=-1;
    operations.doc("lDRGm5pwmrEvHXXgMEUu").get().then((DocumentSnapshot snapshot){
      if(snapshot.exists){
        print("exists ${snapshot.data()} ${snapshot.get("currentStage")}");
        status= snapshot.get('currentStage');
        print(status);
      }else{
        print("nada");
      }
    });
    return status;
  }



  Future<String?> addLiveOperation() async{
     DocumentSnapshot? operation=await operations.where("companyId", isEqualTo: this.companyId).where("operationStatus", isEqualTo: 'live').get().then((QuerySnapshot snapshot){
      if(snapshot.size!=0){
        return snapshot.docs[0];
      }else{
        return null;
      }
    });


    bool isEngaged=await operations.where("companyId", isEqualTo: this.companyId).where("engaged", isEqualTo: true).get().then((QuerySnapshot snapshot){
      if(snapshot.size==0){
        return false;
      }else{
        return true;
      }
    });
    print(isEngaged);

    if(!isEngaged){
      var docX= operations.add({
        'companyId': this.companyId,
        'startDate': DateFormat('yMd').format(now),
        'startTime': DateFormat('kk:mm:ss').format(now),
        'operationStatus':'live',
        'engaged':true,
        'currentStage': 1,
        'engaged_lifeguard':lifeguardSingleton.uid.toString(),
      }).then((value) =>  value.id)
          .catchError((e)=>print(e.toString()));
      
      return docX;
    }else{
      print("already engaged");
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
          temp['engaged']=querySnapshot.docs[0].get('isEngaged');
          return temp;
        }
    });
    return op;
  } 
  
  Future<void> checkDisengagement() async{
    Map op={'operationDoc': null, 'isLive': false};
  }


  Stream<DocumentSnapshot> get liveOpdata{
    return operations.doc(lifeguardSingleton.company.companyId).snapshots();
  }
  
  Stream<QuerySnapshot?> get EngagementStatus{
    return operations.where('companyId', isEqualTo: this.companyId).where('operationStatus', isEqualTo: 'live').where('engaged', isEqualTo: false).snapshots();
  }



}
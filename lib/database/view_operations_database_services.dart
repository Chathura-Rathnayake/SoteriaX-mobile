import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';

class ViewOperationDBServices{
  LifeguardSingleton lifeguardSingleton=LifeguardSingleton();
  String? companyId;
  String? operationId;
  ViewOperationDBServices({this.operationId}){
    companyId=lifeguardSingleton.company.companyId!;
  }
  final CollectionReference operations=FirebaseFirestore.instance.collection("operations");
  final CollectionReference trainingOp=FirebaseFirestore.instance.collection("trainingOperations");

  Future<Map?> getCurrentLiveOp() async{
    Map? currentOp=await operations.where("companyId", isEqualTo: this.companyId).where("operationStatus",isEqualTo: "live").get().then((QuerySnapshot snapshot) async {
      if(snapshot.size>0){
        Map temp={"currentOp": snapshot.docs[0], "opFlag":"live"};
        return temp;
      }else{
        Map? trainOp=await trainingOp.where("companyID", isEqualTo: this.companyId).where("operationStatus",isEqualTo: "live").get().then((QuerySnapshot snapshot){
          if(snapshot.size>0){
            Map temp={"currentOp": snapshot.docs[0], "opFlag":"training"};
            return temp;
          }else{
            return null;
          }
        });
        if(trainOp==null){
          return null;
        }else{
          return trainOp;
        }
      }
    });

    return currentOp;
  }

  Stream<DocumentSnapshot?> get currentLiveOpdata{
    return operations.doc(this.operationId).snapshots();
  }

  Stream<DocumentSnapshot?> get currentTrainingOpdata{
    return trainingOp.doc(this.operationId).snapshots();
  }


}
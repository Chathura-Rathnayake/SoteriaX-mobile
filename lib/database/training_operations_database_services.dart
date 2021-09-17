import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';

class TrainingOperationsDBServices{
  LifeguardSingleton lifeguardSingleton=LifeguardSingleton();
  String? companyId;
  String? operationId;

  CollectionReference headLifeguards=FirebaseFirestore.instance.collection('headLifeguards');
  CollectionReference trainingOperations=FirebaseFirestore.instance.collection('trainingOperations');

  TrainingOperationsDBServices({this.operationId}){
    companyId=lifeguardSingleton.company.companyId;
  }

  Future<int> getRPILastTimestamp() async{
    int rpiTimeStamp=await headLifeguards.doc(this.companyId).get().then((doc){
      return doc.get('piLastOnlineTime');
    });

    return rpiTimeStamp;
  }

  Future<void> stopWatchPing(int stopWatchValue) async{
    print('here');
    return trainingOperations.doc(operationId).update({
      'lastestTimePing': {
        'stopWatch': stopWatchValue,
        'timePing': Timestamp.now(),
      }
    }).then((value) => print('stopwatch pinged')).onError((error, stackTrace) => print('error in ping: $error'));
  }

  Future<Map?> getLastestTimePing() async{
    Map? lastestTimePings=trainingOperations.doc(operationId).get().then((DocumentSnapshot snap){
      var temp={'stopWatch': 0, 'timePing': null}
      if(snap.exists){
        temp['stopWatch']=snap.get('lastestTimePings')['stopWatch'];
        temp['timePing']=snap.get('lastestTimePings')['timePing'];
        return temp;
      }else{
        return temp;
      }
    }) as Map?;

    return lastestTimePings;
  }

}
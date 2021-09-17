import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';

class TrainingOperationsDBServices {
  LifeguardSingleton lifeguardSingleton = LifeguardSingleton();
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
    Map? lastestTimePings;
    lastestTimePings=await trainingOperations.doc(operationId).get().then((DocumentSnapshot snap){
      var temp={};
      if(snap.exists){
        temp['stopWatch']=snap.get('lastestTimePing')['stopWatch'];
        var stamp=snap.get('lastestTimePing')['timePing'];
        temp['timePing']=stamp;
        return temp;
      }else{
        return temp;
      }
    });

    return lastestTimePings;
  }

  Future<void> setCodes(msg) async {
    var codeArray = [];
    var a = msg;
    trainingOperations
        .doc(operationId)

        /// TODO need to add the doc id in startup
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        codeArray = documentSnapshot.get('emergencyCode');
        print('Document data: ${codeArray}');
        codeArray = [a, ...codeArray];
        trainingOperations
            .doc(operationId)
            .update({'emergencyCode': codeArray})
            .then((value) => print("worked"))
            .catchError((error) => print("Failed to Connect"));
      } else {
        print('Document does not exist on the database');
      }
    });

    return trainingOperations
        .doc(operationId)
        .update({'emergencyCodes': codeArray})
        .then((value) => print("worked"))
        .catchError((error) => print("Failed to Conenct"));
  }
}
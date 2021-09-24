import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TrainingOperationsDBServices {
  LifeguardSingleton lifeguardSingleton = LifeguardSingleton();
  String? companyId;
  String? operationId;

  final _stages = [
    'Mission Initiated',
    'Reached Victim',
    'Rest-Tube Dropped',
    'Lifeguard Reached',
    'Mission Completed',
    'Video is being uploaded',
    'Mission Ended',
  ];

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
        temp['operationStatus']=snap.get('operationStatus');
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


  //operations

  Future<bool> initiateOperation(int stopWatchVal) async{
    DocumentSnapshot operationDoc =
    await trainingOperations.doc(operationId).get().then((value) => value);
    bool initiated=false;

    if (operationDoc.get("currentStage") < 1) {
      var timeline = operationDoc.get("timeline");
      var trainingTimes=operationDoc.get('trainingTimes');
      timeline[0] = Timestamp.now().millisecondsSinceEpoch;
      trainingTimes[0]=stopWatchVal;
      initiated=await trainingOperations
          .doc(operationId)
          .update({
      'currentStage': 1,
      'currentStatus': _stages[0],
      'engaged': true,
      'engagedLifeguard': {
          'userID': LifeguardSingleton().uid,
          'userType': LifeguardSingleton().designation,
        },
        'operationStatus': 'live',
        'timeline': timeline,
        'trainingTimes': trainingTimes,
      })
          .then((value){
        print("initiated");
        return true;
      })
          .onError((error, stackTrace) {
        print('error initiating');
        return false;
      });
    } else {
      print("continuing training operation");
    }

    return initiated;

  }

  Future<void> emmitAudio(int stopWatchVal) async {
    DocumentSnapshot operationDoc =
    await trainingOperations.doc(operationId).get().then((value) => value);

    if (operationDoc.get("currentStage") < 2) {
      var timeline = operationDoc.get("timeline");
      var trainingTimes=operationDoc.get('trainingTimes');
      timeline[1] = Timestamp.now().millisecondsSinceEpoch;
      trainingTimes[1]=stopWatchVal;
      trainingOperations
          .doc(operationId)
          .update({
        'currentStage': 2,
        'currentStatus': _stages[1],
        'timeline': timeline,
        'trainingTimes': trainingTimes,
      })
          .then((value) => print("emmited"))
          .onError((error, stackTrace) => print('error emitting'));
    } else {
      print("already updated the status of emitted audio");
    }
  }

  Future<void> dropPackage(int stopWatchVal) async {
    DocumentSnapshot operationDoc =
    await trainingOperations.doc(operationId).get().then((value) => value);

    if (operationDoc.get("currentStage") < 3) {
      var timeline = operationDoc.get("timeline");
      var trainingTimes=operationDoc.get('trainingTimes');
      timeline[2] = Timestamp.now().millisecondsSinceEpoch;
      trainingTimes[2]=stopWatchVal;
      trainingOperations
          .doc(operationId)
          .update({
        'currentStage': 3,
        'currentStatus': _stages[2],
        'timeline': timeline,
        'trainingTimes': trainingTimes,
      })
          .then((value) => print("ended"))
          .onError((error, stackTrace) => print('error'));
    } else {
      print("already updated the status of dropping rest-tube");
    }
  }

  Future<void> streamAudio(int stopWatchVal) async {
    DocumentSnapshot operationDoc =
    await trainingOperations.doc(operationId).get().then((value) => value);

    var timeline = operationDoc.get("timeline");
    timeline[3] = Timestamp.now().millisecondsSinceEpoch;

    if (operationDoc.get("currentStage") < 4) {
      var timeline = operationDoc.get("timeline");
      var trainingTimes=operationDoc.get('trainingTimes');
      timeline[3] = Timestamp.now().millisecondsSinceEpoch;
      trainingTimes[3]=stopWatchVal;
      trainingOperations
          .doc(operationId)
          .update({
        'currentStage': 4,
        'currentStatus': _stages[3],
        'timeline': timeline,
        'trainingTimes': trainingTimes
      })
          .then((value) => print("streamed"))
          .onError((error, stackTrace) => print('error streaming'));
    } else {
      print("Already updated of the streamed audio");
    }
  }

  Future<void> endOperation(int stopWatchVal) async {
    DocumentSnapshot operationDoc =
    await trainingOperations.doc(operationId).get().then((value) => value);

    if (operationDoc.get('currentStage') >= 3) {
      var timeline = operationDoc.get("timeline");
      var trainingTimes=operationDoc.get('trainingTimes');
      timeline[4] = Timestamp.now().millisecondsSinceEpoch;
      trainingTimes[4]=stopWatchVal;
      trainingOperations
          .doc(operationId)
          .update({
        'currentStage': 5,
        'currentStatus': _stages[4],
        'endTime': Timestamp.now(),
        'timeline': timeline,
        'trainingTimes': trainingTimes
      })
          .then((value) => print("ended"))
          .onError((error, stackTrace) => print('error'));
    } else {
      print("Cannot end mission without completing");
    }
  }

  Future<void> forceEndOperation(int stopWatchVal) async {
    DocumentSnapshot operationDoc =
    await trainingOperations.doc(operationId).get().then((value) => value);

    var timeline = operationDoc.get("timeline");
    var trainingTimes=operationDoc.get('trainingTimes');
    timeline[4] = Timestamp.now().millisecondsSinceEpoch;
    trainingTimes[4]=stopWatchVal;

    trainingOperations
        .doc(operationId)
        .update({
      'currentStage': 5,
      'currentStatus': _stages[4],
      'endTime': Timestamp.now(),
      'timeline': timeline,
      'trainingTimes': trainingTimes
    })
        .then((value) => print("ended"))
        .onError((error, stackTrace) => print('error'));
  }

  Stream<DocumentSnapshot?> get getTrainingOp{
    return trainingOperations.doc(operationId).snapshots();
  }

  Stream<QuerySnapshot> get getLiveTrainingOperationData{
    return trainingOperations .where('companyID', isEqualTo: this.companyId).where('operationStatus', isEqualTo: 'live').snapshots();
  }


}
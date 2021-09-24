import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';

class LiveOperationDBServices {
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

  LiveOperationDBServices({this.operationId}) {
    companyId = lifeguardSingleton.company.companyId!;
  }

  final CollectionReference operations =
      FirebaseFirestore.instance.collection("operations");

  Future<void> pingEngagement() async {
    return operations
        .doc(operationId)
        .update({'engagementPing': Timestamp.now()})
        .then((value) => print("pinged"))
        .catchError((error) => print("Failed to ping: $error, $operationId"));
  }

  Future<void> setEngaged() async {
    print("setted");
    return operations
        .doc(operationId)
        .update({
          'isEngaged': true,
          'engaged': true,
          'engagedLifeguard': {
            'userFlag': lifeguardSingleton.designation,
            'userId': lifeguardSingleton.uid
          }
        })
        .then((value) => print('set engaged'))
        .catchError((error) => print("failed to set engaged: $error"));
  }

  Future<void> endOperation() async {
    DocumentSnapshot operationDoc =
        await operations.doc(operationId).get().then((value) => value);

    if (operationDoc.get('currentStage') >= 3) {
      var timeline = operationDoc.get("timeline");
      timeline[4] = Timestamp.now().millisecondsSinceEpoch;
      operations
          .doc(operationId)
          .update({
            'currentStage': 5,
            'currentStatus': _stages[4],
            'endTime': Timestamp.now(),
            'timeline': timeline
          })
          .then((value) => print("ended"))
          .onError((error, stackTrace) => print('error'));
    } else {
      print("Cannot end mission without completing");
    }
  }

  Future<void> dropPackage() async {
    DocumentSnapshot operationDoc =
        await operations.doc(operationId).get().then((value) => value);

    if (operationDoc.get("currentStage") < 3) {
      var timeline = operationDoc.get("timeline");
      timeline[2] = Timestamp.now().millisecondsSinceEpoch;
      operations
          .doc(operationId)
          .update({
            'currentStage': 3,
            'currentStatus': _stages[2],
            'timeline': timeline
          })
          .then((value) => print("ended"))
          .onError((error, stackTrace) => print('error'));
    } else {
      print("already updated the status of emitted audio");
    }
  }

  Future<void> emmitAudio() async {
    DocumentSnapshot operationDoc =
        await operations.doc(operationId).get().then((value) => value);

    if (operationDoc.get("currentStage") < 2) {
      var timeline = operationDoc.get("timeline");
      timeline[1] = Timestamp.now().millisecondsSinceEpoch;
      operations
          .doc(operationId)
          .update({
            'currentStage': 2,
            'currentStatus': _stages[1],
            'timeline': timeline
          })
          .then((value) => print("emmited"))
          .onError((error, stackTrace) => print('error emitting'));
    } else {
      print("already updated the status of emitted audio");
    }
  }

  Future<void> streamAudio() async {
    DocumentSnapshot operationDoc =
        await operations.doc(operationId).get().then((value) => value);

    var timeline = operationDoc.get("timeline");
    timeline[3] = Timestamp.now().millisecondsSinceEpoch;

    if (operationDoc.get("currentStage") == 3) {
      var timeline = operationDoc.get("timeline");
      timeline[3] = Timestamp.now().millisecondsSinceEpoch;
      operations
          .doc(operationId)
          .update({
            'currentStage': 4,
            'currentStatus': _stages[3],
            'timeline': timeline
          })
          .then((value) => print("streamed"))
          .onError((error, stackTrace) => print('error streaming'));
    } else {
      print("Already updated of the streamed audio");
    }
  }

  Future<void> forceEndOperation() async {
    DocumentSnapshot operationDoc =
        await operations.doc(operationId).get().then((value) => value);

    var timeline = operationDoc.get("timeline");
    timeline[4] = Timestamp.now().millisecondsSinceEpoch;

    operations
        .doc(operationId)
        .update({
          'currentStage': 5,
          'currentStatus': _stages[4],
          'endTime': Timestamp.now(),
          'timeline': timeline
        })
        .then((value) => print("ended"))
        .onError((error, stackTrace) => print('error'));
  }

  Future<void> setCodes(msg) async {
    var codeArray = [];
    var a = msg;
    operations
        .doc(operationId)

    /// TODO need to add the doc id in startup
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        codeArray = documentSnapshot.get('emergencyCode');
        print('Document data: ${codeArray}');
        codeArray = [a, ...codeArray];
        operations
            .doc(operationId)
            .update({'emergencyCode': codeArray})
            .then((value) => print("worked"))
            .catchError((error) => print("Failed to Connect"));
      } else {
        print('Document does not exist on the database');
      }
    });
  }
  Stream<DocumentSnapshot?> get getOperation {
    return operations.doc(operationId).snapshots();
  }
}

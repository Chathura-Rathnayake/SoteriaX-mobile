import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';

class TrainingOperationsDBServices {
  LifeguardSingleton lifeguardSingleton = LifeguardSingleton();
  String? companyId;
  String? operationId;

  CollectionReference headLifeguards =
      FirebaseFirestore.instance.collection('headLifeguards');
  final CollectionReference training =
      FirebaseFirestore.instance.collection("trainingOperations");
  TrainingOperationsDBServices({this.operationId}) {
    companyId = lifeguardSingleton.company.companyId;
  }

  Stream<DocumentSnapshot?> get getRpiStatus {
    return headLifeguards.doc(this.companyId).snapshots();
  }

  Future<void> setCodes(msg) async {
    var codeArray = [];
    var a = msg;
    training
        .doc("WuAArb3cGaHTWpMMxrdG")

        /// TODO need to add the doc id in startup
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        codeArray = documentSnapshot.get('emergencyCode');
        print('Document data: ${codeArray}');
        codeArray = [a, ...codeArray];
        training
            .doc("WuAArb3cGaHTWpMMxrdG")
            .update({'emergencyCode': codeArray})
            .then((value) => print("worked"))
            .catchError((error) => print("Failed to Conenct"));
      } else {
        print('Document does not exist on the database');
      }
    });

    return training
        .doc("WuAArb3cGaHTWpMMxrdG")
        .update({'emergencyCodes': codeArray})
        .then((value) => print("worked"))
        .catchError((error) => print("Failed to Conenct"));
  }
}

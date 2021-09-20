
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';

class GetHelpRequestsDB{
  CollectionReference helpRequests=FirebaseFirestore.instance.collection('helpRequests');
  LifeguardSingleton lifeguardSingleton=LifeguardSingleton();

  Stream<QuerySnapshot?> get getAllHelpRequests{
    //print('comp: ${lifeguardSingleton.company.companyId}, user: ${lifeguardSingleton.uid}');
    print(helpRequests.where('companyID', isEqualTo: lifeguardSingleton.company.companyId).
    where("userID", isEqualTo: lifeguardSingleton.uid).snapshots());
    return helpRequests.where('companyID', isEqualTo: lifeguardSingleton.company.companyId).
    where("name", isEqualTo: '${lifeguardSingleton.firstname} ${lifeguardSingleton.lastname}')
        .orderBy('date').snapshots();
  }









}
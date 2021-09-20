
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';

class GetSuggestionsDB{
  CollectionReference suggestions=FirebaseFirestore.instance.collection('suggestions');
  LifeguardSingleton lifeguardSingleton=LifeguardSingleton();

  Stream<QuerySnapshot?> get getAllSuggestions{
    //print('comp: ${lifeguardSingleton.company.companyId}, user: ${lifeguardSingleton.uid}');
    print(suggestions.where('companyID', isEqualTo: lifeguardSingleton.company.companyId).
    where("userID", isEqualTo: lifeguardSingleton.uid).snapshots());
    return suggestions.where('companyID', isEqualTo: lifeguardSingleton.company.companyId).
    where("name", isEqualTo: '${lifeguardSingleton.firstname} ${lifeguardSingleton.lastname}')
        .orderBy('date').snapshots();
  }









}
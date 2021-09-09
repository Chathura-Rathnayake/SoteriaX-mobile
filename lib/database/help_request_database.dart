

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';

class HelpRequestDB{
  LifeguardSingleton lifeguardSingleton=LifeguardSingleton();

   final CollectionReference helpRequests=FirebaseFirestore.instance.collection('helpRequests');


   Future<void> addRequest(String name, String age){
     return helpRequests.add({
       'name': name,
       'age': age,
       'lifeguardName': '${lifeguardSingleton.firstname} ${lifeguardSingleton.lastname}'
     }).then((value) => print(value.id)).catchError((e)=>print(e.toString()));
   }

}